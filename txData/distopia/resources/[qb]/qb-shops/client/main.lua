local QBCore
local currentShop, playerData
local pedSpawned = false
local listen = false
local ShopPed = {}
local NewZones = {}

-- Functions

local function GetQBCore()
    if QBCore then return QBCore end

    while GetResourceState('qb-core') ~= 'started' do
        Wait(100)
    end

    while not QBCore do
        local ok, core = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if ok and core then
            QBCore = core
        else
            Wait(100)
        end
    end

    return QBCore
end

CreateThread(function()
    GetQBCore()
end)

local function refreshPlayerData()
    playerData = GetQBCore().Functions.GetPlayerData()
    return playerData
end

local function createBlips()
    if pedSpawned then return end

    for store in pairs(Config.Locations) do
        if Config.Locations[store]['showblip'] then
            local StoreBlip = AddBlipForCoord(Config.Locations[store]['coords']['x'], Config.Locations[store]['coords']['y'], Config.Locations[store]['coords']['z'])
            SetBlipSprite(StoreBlip, Config.Locations[store]['blipsprite'])
            SetBlipScale(StoreBlip, Config.Locations[store]['blipscale'])
            SetBlipDisplay(StoreBlip, 4)
            SetBlipColour(StoreBlip, Config.Locations[store]['blipcolor'])
            SetBlipAsShortRange(StoreBlip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(Config.Locations[store]['label'])
            EndTextCommandSetBlipName(StoreBlip)
        end
    end
end

local function listenForControl()
    if listen then return end
    CreateThread(function()
        listen = true
        local nextPromptRefresh = 0
        local nextInteraction = 0
        while listen do
            if currentShop and GetGameTimer() >= nextPromptRefresh then
                exports['qb-core']:DrawText(Lang:t('info.open_shop'), 'left', 'qb-shops')
                nextPromptRefresh = GetGameTimer() + 500
            end

            if currentShop and IsControlJustPressed(0, 38) and GetGameTimer() >= nextInteraction then -- E
                nextInteraction = GetGameTimer() + 1000
                exports['qb-core']:KeyPressed()
                TriggerServerEvent('qb-shops:server:openShop', { shop = currentShop })
            end
            Wait(0)
        end
    end)
end

local function createPeds()
    if pedSpawned then return end
    local defaultTargetIcon = 'fas fa-shopping-cart'
    local defaultTargetLabel = 'Abrir loja'

    for k, v in pairs(Config.Locations) do
        if not v.ped then
            exports['qb-target']:AddCircleZone(k, vector3(v.coords.x, v.coords.y, v.coords.z), 0.5, {
                name = k,
                debugPoly = false,
                useZ = true
            }, {
                options = {
                    {
                        label = v.targetLabel or defaultTargetLabel,
                        icon = v.targetIcon or defaultTargetIcon,
                        item = v.requiredItem,
                        type = 'server',
                        event = 'qb-shops:server:openShop',
                        shop = k,
                        job = v.requiredJob,
                        gang = v.requiredGang
                    }
                },
                distance = 2.0
            })
        else
            local current = type(v['ped']) == 'number' and v['ped'] or joaat(v['ped'])
            RequestModel(current)
            while not HasModelLoaded(current) do Wait(0) end
            ShopPed[k] = CreatePed(0, current, v['coords'].x, v['coords'].y, v['coords'].z - 1, v['coords'].w, false, false)
            TaskStartScenarioInPlace(ShopPed[k], v['scenario'], 0, true)
            FreezeEntityPosition(ShopPed[k], true)
            SetEntityInvincible(ShopPed[k], true)
            SetBlockingOfNonTemporaryEvents(ShopPed[k], true)
            if Config.UseTarget then
                exports['qb-target']:AddTargetEntity(ShopPed[k], {
                    options = {
                        {
                            label = v.targetLabel or defaultTargetLabel,
                            icon = v.targetIcon or defaultTargetIcon,
                            item = v.requiredItem,
                            type = 'server',
                            event = 'qb-shops:server:openShop',
                            shop = k,
                            job = v.requiredJob,
                            gang = v.requiredGang
                        }
                    },
                    distance = 2.0
                })
            end
        end
    end
    pedSpawned = true
end

local function deletePeds()
    if not pedSpawned then return end
    for _, v in pairs(ShopPed) do
        DeletePed(v)
    end
    pedSpawned = false
end

local function tableCheck(inputValue, requiredValue)
    if not inputValue or not inputValue.job or not inputValue.gang then return false end
    local playerJob = inputValue.job.name
    local playerJobGrade = inputValue.job.grade and inputValue.job.grade.level or 0
    local playerGang = inputValue.gang.name
    local playerGangGrade = inputValue.gang.grade and inputValue.gang.grade.level or 0
    local shopData = Config.Locations[requiredValue]
    if not shopData then return false end

    local jobCheck = false
    local gangCheck = false
    local itemCheck = false

    if shopData.requiredJob then
        if type(shopData.requiredJob) == 'table' then
            for job, grade in pairs(shopData.requiredJob) do
                if playerJob == job and playerJobGrade >= grade then
                    jobCheck = true
                    break
                end
            end
        elseif playerJob == shopData.requiredJob then
            jobCheck = true
        end
    else
        jobCheck = true
    end

    if shopData.requiredGang then
        if type(shopData.requiredGang) == 'table' then
            for gang, grade in pairs(shopData.requiredGang) do
                if playerGang == gang and playerGangGrade >= grade then
                    gangCheck = true
                    break
                end
            end
        elseif playerGang == shopData.requiredGang then
            gangCheck = true
        end
    else
        gangCheck = true
    end

    if shopData.requiredItem then
        itemCheck = exports['qb-inventory']:HasItem(shopData.requiredItem)
    else
        itemCheck = true
    end

    return jobCheck and gangCheck and itemCheck
end

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    refreshPlayerData()
    createBlips()
    createPeds()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    playerData = {}
    deletePeds()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(jobInfo)
    playerData.job = jobInfo
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    refreshPlayerData()
    createBlips()
    createPeds()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    deletePeds()
end)

-- Threads
if Config.UseTextPrompt then
    CreateThread(function()
        for shop in pairs(Config.Locations) do
            NewZones[#NewZones + 1] = CircleZone:Create(vector3(Config.Locations[shop]['coords']['x'], Config.Locations[shop]['coords']['y'], Config.Locations[shop]['coords']['z']), Config.Locations[shop]['radius'] or 1.5, {
                useZ = true,
                debugPoly = false,
                name = shop,
            })
        end

        local combo = ComboZone:Create(NewZones, { name = 'RandomZOneName', debugPoly = false })
        combo:onPlayerInOut(function(isPointInside, _, zone)
            if isPointInside then
                refreshPlayerData()
                if tableCheck(playerData, zone.name) then
                    currentShop = zone.name
                    exports['qb-core']:DrawText(Lang:t('info.open_shop'), 'left', 'qb-shops')
                    listenForControl()
                else
                    currentShop = nil
                    exports['qb-core']:HideText('qb-shops')
                    listen = false
                end
            else
                currentShop = nil
                exports['qb-core']:HideText('qb-shops')
                listen = false
            end
        end)
    end)
end
