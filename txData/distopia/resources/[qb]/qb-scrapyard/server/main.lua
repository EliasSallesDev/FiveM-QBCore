local QBCore = exports['qb-core']:GetCoreObject()

local ActiveJobs = {}
local Cooldowns = {}

local function getVehicleLabel(model)
    local vehicle = QBCore.Shared.Vehicles[model]
    if not vehicle then return model end
    return (vehicle.brand and vehicle.brand .. ' ' or '') .. vehicle.name
end

local function randomPlate()
    return ('SC%05d'):format(math.random(0, 99999))
end

local function pickRarity()
    local total = 0
    for _, data in pairs(Config.Rarities) do
        total = total + data.chance
    end

    local roll = math.random(1, total)
    local current = 0
    for rarity, data in pairs(Config.Rarities) do
        current = current + data.chance
        if roll <= current then
            return rarity, data
        end
    end

    return 'common', Config.Rarities.common
end

local function finishJob(src)
    ActiveJobs[src] = nil
    Cooldowns[src] = os.time() + Config.Job.cooldown
end

local function addReward(src, rarityData)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local payout = math.random(rarityData.payout.min, rarityData.payout.max)
    local depositReturn = Config.Job.deposit
    Player.Functions.AddMoney('cash', payout + depositReturn, 'scrapyard-job-complete')

    for _ = 1, math.random(rarityData.itemRolls.min, rarityData.itemRolls.max) do
        local item = Config.Items[math.random(1, #Config.Items)]
        local amount = math.random(rarityData.itemAmount.min, rarityData.itemAmount.max)
        exports['qb-inventory']:AddItem(src, item, amount, false, false, 'qb-scrapyard:server:CompleteJob')
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', amount)
        Wait(250)
    end

    if math.random(1, 100) <= rarityData.rubberChance then
        local amount = math.random(rarityData.rubberAmount.min, rarityData.rubberAmount.max)
        exports['qb-inventory']:AddItem(src, 'rubber', amount, false, false, 'qb-scrapyard:server:CompleteJob')
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items.rubber, 'add', amount)
    end

    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.job_complete', { value = payout + depositReturn }), 'success')
end

RegisterNetEvent('qb-scrapyard:server:LoadVehicleList', function()
    local src = source
    if ActiveJobs[src] then
        TriggerClientEvent('qb-scrapyard:client:StartJob', src, ActiveJobs[src])
    end
end)

RegisterNetEvent('qb-scrapyard:server:RequestJob', function(locationId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if ActiveJobs[src] then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.active_job'), 'error')
        return
    end

    if Cooldowns[src] and Cooldowns[src] > os.time() then
        local remaining = math.ceil((Cooldowns[src] - os.time()) / 60)
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cooldown', { value = remaining }), 'error')
        return
    end

    local totalCost = Config.Job.rentalFee + Config.Job.deposit
    if Player.PlayerData.money.cash < totalCost then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_enough_money', { value = totalCost }), 'error')
        return
    end

    local location = Config.Locations[locationId or 1] or Config.Locations[1]
    local rarity, rarityData = pickRarity()
    local vehicles = Config.VehiclesByRarity[rarity] or Config.VehiclesByRarity.common
    local vehicle = vehicles[math.random(1, #vehicles)]
    local zone = Config.SearchZones[math.random(1, #Config.SearchZones)]
    local spawn = zone.spawns[math.random(1, #zone.spawns)]

    Player.Functions.RemoveMoney('cash', totalCost, 'scrapyard-tow-rental')

    ActiveJobs[src] = {
        locationId = locationId or 1,
        vehicle = vehicle,
        vehicleLabel = getVehicleLabel(vehicle),
        rarity = rarity,
        rarityLabel = rarityData.label,
        zoneName = zone.name,
        zoneLabel = zone.label,
        zoneHint = zone.hint,
        zoneCenter = zone.center,
        zoneRadius = zone.radius,
        spawn = spawn,
        targetPlate = randomPlate(),
        towPlate = randomPlate(),
        towSpawn = location.towSpawn,
        expiresAt = os.time() + Config.Job.expiry,
    }

    TriggerClientEvent('qb-scrapyard:client:StartJob', src, ActiveJobs[src])
end)

RegisterNetEvent('qb-scrapyard:server:RegisterTargetVehicle', function(netId, plate)
    local src = source
    local job = ActiveJobs[src]
    if not job or job.targetNetId then return end

    local ped = GetPlayerPed(src)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if vehicle == 0 or not DoesEntityExist(vehicle) then return end

    local playerCoords = GetEntityCoords(ped)
    local vehicleCoords = GetEntityCoords(vehicle)
    if #(playerCoords - vehicleCoords) > Config.Job.targetRegisterDistance then return end
    if GetEntityModel(vehicle) ~= joaat(job.vehicle) then return end
    if plate ~= job.targetPlate then return end

    job.targetNetId = netId
end)

RegisterNetEvent('qb-scrapyard:server:CompleteJob', function(netId)
    local src = source
    local job = ActiveJobs[src]
    if not job then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.no_active_job'), 'error')
        return
    end

    if job.expiresAt < os.time() then
        finishJob(src)
        TriggerClientEvent('qb-scrapyard:client:ClearJob', src)
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.expired'), 'error')
        return
    end

    if job.targetNetId and netId ~= job.targetNetId then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.wrong_vehicle'), 'error')
        return
    end

    local ped = GetPlayerPed(src)
    local targetVehicle = NetworkGetEntityFromNetworkId(netId)
    if targetVehicle == 0 or not DoesEntityExist(targetVehicle) then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.vehicle_missing'), 'error')
        return
    end

    local location = Config.Locations[job.locationId] or Config.Locations[1]
    if #(GetEntityCoords(ped) - location.deliver.coords) > Config.Job.deliveryDistance then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.too_far'), 'error')
        return
    end

    if #(GetEntityCoords(targetVehicle) - location.deliver.coords) > Config.Job.deliveryDistance then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.vehicle_too_far'), 'error')
        return
    end

    if GetEntityModel(targetVehicle) ~= joaat(job.vehicle) then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.wrong_vehicle'), 'error')
        return
    end

    local plate = string.gsub(GetVehicleNumberPlateText(targetVehicle) or '', '%s+', '')
    if plate ~= job.targetPlate then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.wrong_vehicle'), 'error')
        return
    end

    addReward(src, Config.Rarities[job.rarity] or Config.Rarities.common)
    finishJob(src)
    TriggerClientEvent('qb-scrapyard:client:FinishJob', src, netId)
end)

RegisterNetEvent('qb-scrapyard:server:CancelJob', function()
    local src = source
    if not ActiveJobs[src] then return end
    finishJob(src)
    TriggerClientEvent('qb-scrapyard:client:ClearJob', src)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('error.job_canceled'), 'error')
end)

AddEventHandler('playerDropped', function()
    local src = source
    ActiveJobs[src] = nil
end)
