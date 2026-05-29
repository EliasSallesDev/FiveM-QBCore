local QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = {}
local ActiveContract = nil
local CurrentBlip = nil
local DepotBlips = {}
local NearDepot = false
local NearPickup = false
local NearDropoff = false
local Busy = false

local function notify(message, notifyType, data)
    QBCore.Functions.Notify(Lang:t(message, data or {}), notifyType or 'primary')
end

local function toVector3(coords)
    return vector3(coords.x, coords.y, coords.z)
end

local function removeRouteBlip()
    if CurrentBlip then
        RemoveBlip(CurrentBlip)
        CurrentBlip = nil
    end
end

local function setRouteBlip(coords, sprite, color)
    removeRouteBlip()
    CurrentBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(CurrentBlip, sprite or 479)
    SetBlipDisplay(CurrentBlip, 4)
    SetBlipScale(CurrentBlip, 0.75)
    SetBlipColour(CurrentBlip, color or 5)
    SetBlipRoute(CurrentBlip, true)
    SetBlipRouteColour(CurrentBlip, color or 5)
end

local function clearContract()
    ActiveContract = nil
    NearPickup = false
    NearDropoff = false
    removeRouteBlip()
    exports['qb-core']:HideText()
end

local function getPlayerVehicle()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return nil end

    local vehicle = GetVehiclePedIsIn(ped, false)
    if GetPedInVehicleSeat(vehicle, -1) ~= ped then return nil end

    return vehicle
end

local function getVehicleNetId()
    local vehicle = getPlayerVehicle()
    if not vehicle then return nil end
    return VehToNet(vehicle)
end

local function syncRouteFromContract(contract, status)
    ActiveContract = contract
    ActiveContract.status = status or ActiveContract.status or 'accepted'

    if ActiveContract.status == 'loaded' then
        setRouteBlip(ActiveContract.dropoff, 478, 2)
        notify('text.go_dropoff', 'primary')
    else
        setRouteBlip(ActiveContract.pickup, 479, 5)
        notify('text.go_pickup', 'primary')
    end
end

local function handleResponse(response)
    if not response or not response.ok then
        notify('error.' .. (response and response.message or 'no_active'), 'error')
        return false
    end
    return true
end

local function startContract(contractId)
    local netId = getVehicleNetId()
    if not netId then
        return notify('error.no_vehicle', 'error')
    end

    QBCore.Functions.TriggerCallback('trucking:server:startContract', function(response)
        if not handleResponse(response) then return end

        notify('success.started', 'success', { plate = response.plate })
        syncRouteFromContract(response.contract, 'accepted')
    end, contractId, netId)
end

local function cancelContract()
    QBCore.Functions.TriggerCallback('trucking:server:cancelContract', function(response)
        if not handleResponse(response) then return end
        clearContract()
        notify('text.route_cancelled', 'primary')
    end)
end

local function openDepotMenu()
    QBCore.Functions.TriggerCallback('trucking:server:getStatus', function(response)
        if not handleResponse(response) then return end

        local menu = {
            {
                header = Lang:t('menu.header'),
                txt = Lang:t('menu.rep', { rep = response.rep, tier = Lang:t(response.tierLabelKey) }),
                isMenuHeader = true,
            },
        }

        if response.active then
            menu[#menu + 1] = {
                header = Lang:t('menu.active_header'),
                txt = Lang:t('menu.cancel'),
                params = {
                    event = 'trucking:client:CancelContract',
                },
            }
        end

        for _, contract in ipairs(response.contracts) do
            local locked = response.rep < contract.minRep
            menu[#menu + 1] = {
                header = Lang:t(contract.labelKey),
                txt = locked
                    and Lang:t('menu.locked', { rep = contract.minRep })
                    or (Lang:t(contract.descKey) .. '<br>' .. Lang:t('menu.pay', {
                        pay = contract.basePay,
                        rep = contract.rep,
                        time = contract.timeLimit,
                    })),
                disabled = locked or response.active ~= nil,
                params = {
                    event = 'trucking:client:StartContract',
                    args = contract.id,
                },
            }
        end

        menu[#menu + 1] = {
            header = Lang:t('menu.close'),
            params = {
                event = 'qb-menu:client:closeMenu',
            },
        }

        exports['qb-menu']:openMenu(menu)
    end)
end

local function progress(name, label, duration, cb)
    Busy = true
    QBCore.Functions.Progressbar(name, label, duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        Busy = false
        cb()
    end, function()
        Busy = false
        notify('error.cancelled', 'error')
    end)
end

local function loadCargo()
    if Busy then return end
    local netId = getVehicleNetId()
    if not netId then return notify('error.no_vehicle', 'error') end

    progress('qbx_trucking_load', Lang:t('text.loading_cargo'), 4500, function()
        QBCore.Functions.TriggerCallback('trucking:server:loadCargo', function(response)
            if not handleResponse(response) then return end
            notify('success.loaded', 'success')
            syncRouteFromContract(response.contract, 'loaded')
        end, netId)
    end)
end

local function finishContract()
    if Busy then return end
    local netId = getVehicleNetId()
    if not netId then return notify('error.no_vehicle', 'error') end

    progress('qbx_trucking_dropoff', Lang:t('text.delivering_cargo'), 4500, function()
        QBCore.Functions.TriggerCallback('trucking:server:finishContract', function(response)
            if not handleResponse(response) then return end
            notify('success.completed', 'success', { pay = response.pay, rep = response.rep })
            if response.perfect then notify('success.perfect', 'success') end
            if response.foundCrypto then notify('success.found_crypto', 'success') end
            clearContract()
        end, netId)
    end)
end

local function createDepotBlips()
    for _, blip in ipairs(DepotBlips) do
        RemoveBlip(blip)
    end
    DepotBlips = {}

    for _, depot in ipairs(Config.Depots) do
        local blip = AddBlipForCoord(depot.coords.x, depot.coords.y, depot.coords.z)
        SetBlipSprite(blip, depot.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, depot.blip.scale)
        SetBlipColour(blip, depot.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Lang:t(depot.labelKey))
        EndTextCommandSetBlipName(blip)
        DepotBlips[#DepotBlips + 1] = blip
    end
end

RegisterNetEvent('trucking:client:StartContract', function(contractId)
    startContract(contractId)
end)

RegisterNetEvent('trucking:client:CancelContract', function()
    cancelContract()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    createDepotBlips()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    clearContract()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    PlayerData = QBCore.Functions.GetPlayerData()
    createDepotBlips()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for _, blip in ipairs(DepotBlips) do
        RemoveBlip(blip)
    end
    clearContract()
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        NearDepot = false
        NearPickup = false
        NearDropoff = false
        if ActiveContract then
            if ActiveContract.status == 'accepted' and #(coords - toVector3(ActiveContract.pickup)) <= Config.ActionDistance then
                NearPickup = true
                sleep = 0
                DrawMarker(2, ActiveContract.pickup.x, ActiveContract.pickup.y, ActiveContract.pickup.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.35, 0.35, 0.25, 245, 185, 65, 180, false, false, false, true, false, false, false)
            elseif ActiveContract.status == 'loaded' and #(coords - toVector3(ActiveContract.dropoff)) <= Config.ActionDistance then
                NearDropoff = true
                sleep = 0
                DrawMarker(2, ActiveContract.dropoff.x, ActiveContract.dropoff.y, ActiveContract.dropoff.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.35, 0.35, 0.25, 80, 220, 120, 180, false, false, false, true, false, false, false)
            end
        end

        if not NearPickup and not NearDropoff then
            for _, depot in ipairs(Config.Depots) do
                if #(coords - vector3(depot.coords.x, depot.coords.y, depot.coords.z)) <= Config.ActionDistance then
                    NearDepot = true
                    sleep = 0
                    DrawMarker(2, depot.coords.x, depot.coords.y, depot.coords.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.35, 0.35, 0.25, 20, 180, 120, 180, false, false, false, true, false, false, false)
                    break
                end
            end
        end

        if NearDepot then
            exports['qb-core']:DrawText(Lang:t('text.open_depot'), 'left')
            if IsControlJustReleased(0, 38) then openDepotMenu() end
        elseif NearPickup then
            exports['qb-core']:DrawText(Lang:t('text.pickup'), 'left')
            if IsControlJustReleased(0, 38) then loadCargo() end
        elseif NearDropoff then
            exports['qb-core']:DrawText(Lang:t('text.dropoff'), 'left')
            if IsControlJustReleased(0, 38) then finishContract() end
        else
            exports['qb-core']:HideText()
        end

        Wait(sleep)
    end
end)
