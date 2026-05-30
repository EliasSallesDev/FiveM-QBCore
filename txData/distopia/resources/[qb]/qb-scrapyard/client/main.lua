local QBCore = exports['qb-core']:GetCoreObject()

local activeJob = nil
local targetVehicle = nil
local towVehicle = nil
local targetNetId = nil
local searchBlip = nil
local isBusy = false
local listen = false

local function clearBlips()
    if searchBlip then
        RemoveBlip(searchBlip)
        searchBlip = nil
    end
end

local function asVector4(coords)
    return vector4(coords.x, coords.y, coords.z, coords.w or coords.h or 0.0)
end

local function cleanupVehicles(deleteTow)
    if targetVehicle and DoesEntityExist(targetVehicle) then
        SetEntityAsMissionEntity(targetVehicle, true, true)
        DeleteVehicle(targetVehicle)
    end
    if deleteTow and towVehicle and DoesEntityExist(towVehicle) then
        SetEntityAsMissionEntity(towVehicle, true, true)
        DeleteVehicle(towVehicle)
    end
    targetVehicle = nil
    towVehicle = nil
    targetNetId = nil
end

local function createScrapyardBlips()
    for id in pairs(Config.Locations) do
        local blip = AddBlipForCoord(Config.Locations[id].main.x, Config.Locations[id].main.y, Config.Locations[id].main.z)
        SetBlipSprite(blip, 380)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 9)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(Lang:t('text.scrapyard'))
        EndTextCommandSetBlipName(blip)
    end
end

local function createSearchBlip(job)
    clearBlips()

    searchBlip = AddBlipForRadius(job.zoneCenter.x, job.zoneCenter.y, job.zoneCenter.z, job.zoneRadius + 0.0)
    SetBlipSprite(searchBlip, Config.Job.searchBlipSprite)
    SetBlipColour(searchBlip, Config.Job.searchBlipColor)
    SetBlipAlpha(searchBlip, Config.Job.searchBlipAlpha)
end

local function sendJobEmail(job)
    local message = Lang:t('email.message', {
        vehicle = job.vehicleLabel,
        rarity = job.rarityLabel,
        zone = job.zoneLabel,
        hint = job.zoneHint,
        plate = job.targetPlate,
        minutes = math.floor(Config.Job.expiry / 60),
    })

    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = Lang:t('email.sender'),
        subject = Lang:t('email.subject'),
        message = message,
    })
end

local function spawnTowTruck(job)
    if towVehicle and DoesEntityExist(towVehicle) then return end

    QBCore.Functions.SpawnVehicle(Config.Job.towTruckModel, function(vehicle)
        towVehicle = vehicle
        SetVehicleNumberPlateText(vehicle, job.towPlate)
        SetEntityHeading(vehicle, job.towSpawn.w or job.towSpawn.h or 0.0)
        SetVehicleDirtLevel(vehicle, 0.0)
        SetVehicleEngineOn(vehicle, true, true, false)
        TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(vehicle))
        QBCore.Functions.Notify(Lang:t('success.tow_rented'), 'success')
    end, asVector4(job.towSpawn), true, true)
end

local function spawnTargetVehicle(job)
    if targetVehicle and DoesEntityExist(targetVehicle) then return end

    QBCore.Functions.SpawnVehicle(job.vehicle, function(vehicle)
        targetVehicle = vehicle
        SetVehicleNumberPlateText(vehicle, job.targetPlate)
        SetEntityHeading(vehicle, job.spawn.w or job.spawn.h or 0.0)
        SetVehicleDoorsLocked(vehicle, 1)
        SetVehicleEngineOn(vehicle, false, true, true)
        SetVehicleDirtLevel(vehicle, 12.0)
        SetVehicleUndriveable(vehicle, false)
        targetNetId = NetworkGetNetworkIdFromEntity(vehicle)
        CreateThread(function()
            for _ = 1, 10 do
                TriggerServerEvent('qb-scrapyard:server:RegisterTargetVehicle', targetNetId, job.targetPlate)
                Wait(500)
            end
        end)
    end, asVector4(job.spawn), true, false)
end

local function requestJob(locationId)
    if activeJob then
        QBCore.Functions.Notify(Lang:t('error.active_job'), 'error')
        return
    end
    TriggerServerEvent('qb-scrapyard:server:RequestJob', locationId)
end

local function cancelJob()
    if not activeJob then return end
    TriggerServerEvent('qb-scrapyard:server:CancelJob')
end

local function getDeliverableVehicle()
    if targetVehicle and DoesEntityExist(targetVehicle) then
        return targetVehicle
    end

    if targetNetId then
        local vehicle = NetToVeh(targetNetId)
        if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
            targetVehicle = vehicle
            return vehicle
        end
    end

    return nil
end

local function deliverVehicle()
    if not activeJob then
        QBCore.Functions.Notify(Lang:t('error.no_active_job'), 'error')
        return
    end
    if isBusy then return end

    local vehicle = getDeliverableVehicle()
    if not vehicle then
        QBCore.Functions.Notify(Lang:t('error.vehicle_missing'), 'error')
        return
    end

    local ped = PlayerPedId()
    local vehCoords = GetEntityCoords(vehicle)
    local pedCoords = GetEntityCoords(ped)
    local deliverCoords = Config.Locations[activeJob.locationId].deliver.coords
    if #(pedCoords - deliverCoords) > Config.Job.deliveryDistance or #(vehCoords - deliverCoords) > Config.Job.deliveryDistance then
        QBCore.Functions.Notify(Lang:t('error.vehicle_too_far'), 'error')
        return
    end

    isBusy = true
    local scrapTime = math.random(28000, 37000)
    QBCore.Functions.Progressbar('scrap_vehicle', Lang:t('text.demolish_vehicle'), scrapTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'mp_car_bomb',
        anim = 'car_bomb_mechanic',
        flags = 16,
    }, {}, {}, function()
        ClearPedTasks(ped)
        TriggerServerEvent('qb-scrapyard:server:CompleteJob', NetworkGetNetworkIdFromEntity(vehicle))
        isBusy = false
    end, function()
        ClearPedTasks(ped)
        isBusy = false
        QBCore.Functions.Notify(Lang:t('error.canceled'), 'error')
    end)
end

local function keyListener(action, locationId)
    CreateThread(function()
        listen = true
        while listen do
            if IsControlJustPressed(0, 38) then
                exports['qb-core']:KeyPressed()
                if action == 'request' then
                    requestJob(locationId)
                elseif action == 'deliver' then
                    deliverVehicle()
                end
                break
            elseif action == 'request' and IsControlJustPressed(0, 47) then
                exports['qb-core']:KeyPressed()
                cancelJob()
                break
            end
            Wait(0)
        end
    end)
end

local function setupZones()
    local zones = {}

    for id, location in pairs(Config.Locations) do
        if Config.UseTarget then
            exports['qb-target']:AddBoxZone('scrapyard_request_' .. id, location.request.coords, location.request.length, location.request.width, {
                name = 'scrapyard_request_' .. id,
                heading = location.request.heading,
                minZ = location.request.coords.z - 1,
                maxZ = location.request.coords.z + 1,
            }, {
                options = {
                    {
                        action = function()
                            requestJob(id)
                        end,
                        icon = 'fa fa-truck-pickup',
                        label = Lang:t('text.request_job_target'),
                    },
                    {
                        action = function()
                            cancelJob()
                        end,
                        icon = 'fa fa-ban',
                        label = Lang:t('text.cancel_job_target'),
                    },
                },
                distance = 2.0
            })

            exports['qb-target']:AddCircleZone('scrapyard_deliver_' .. id, location.deliver.coords, Config.Job.deliveryDistance, {
                name = 'scrapyard_deliver_' .. id,
                debugPoly = false,
                useZ = false,
            }, {
                options = {
                    {
                        action = function()
                            deliverVehicle()
                        end,
                        icon = 'fa fa-wrench',
                        label = Lang:t('text.disassemble_vehicle_target'),
                    }
                },
                distance = Config.Job.deliveryDistance
            })
        else
            zones[#zones + 1] = { zone = BoxZone:Create(location.request.coords, location.request.length, location.request.width, {
                heading = location.request.heading,
                name = 'scrapyard_request_' .. id,
                debugPoly = false,
                minZ = location.request.coords.z - 1,
                maxZ = location.request.coords.z + 1,
            }), action = 'request', locationId = id }

            zones[#zones + 1] = { zone = CircleZone:Create(location.deliver.coords, Config.Job.deliveryDistance, {
                name = 'scrapyard_deliver_' .. id,
                debugPoly = false,
                useZ = false,
            }), action = 'deliver', locationId = id }
        end
    end

    if not Config.UseTarget then
        for _, entry in pairs(zones) do
            entry.zone:onPlayerInOut(function(isPointInside)
                if isPointInside and not isBusy then
                    if entry.action == 'request' then
                        exports['qb-core']:DrawText(Lang:t('text.request_job'), 'left', 'qb-scrapyard')
                    else
                        exports['qb-core']:DrawText(Lang:t('text.disassemble_vehicle'), 'left', 'qb-scrapyard')
                    end
                    keyListener(entry.action, entry.locationId)
                else
                    listen = false
                    exports['qb-core']:HideText('qb-scrapyard')
                end
            end)
        end
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('qb-scrapyard:server:LoadVehicleList')
end)

RegisterNetEvent('qb-scrapyard:client:StartJob', function(job)
    activeJob = job
    cleanupVehicles(true)
    createSearchBlip(job)
    spawnTowTruck(job)
    spawnTargetVehicle(job)
    sendJobEmail(job)
    QBCore.Functions.Notify(Lang:t('success.job_started', { vehicle = job.vehicleLabel, zone = job.zoneLabel }), 'success', 8000)
end)

RegisterNetEvent('qb-scrapyard:client:FinishJob', function(netId)
    local vehicle = NetToVeh(netId)
    if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
    end
    activeJob = nil
    clearBlips()
    cleanupVehicles(true)
end)

RegisterNetEvent('qb-scrapyard:client:ClearJob', function()
    activeJob = nil
    clearBlips()
    cleanupVehicles(true)
end)

CreateThread(function()
    createScrapyardBlips()
    setupZones()
end)
