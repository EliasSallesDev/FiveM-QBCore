local QBCore = exports['qb-core']:GetCoreObject()

local ActiveContracts = {}
local StartCooldowns = {}
local HashToModel = {}

local function buildModelIndex()
    for _, classData in pairs(Config.VehicleClasses) do
        for model in pairs(classData.models) do
            HashToModel[joaat(model)] = model
        end
    end

    for _, contract in pairs(Config.Contracts) do
        if contract.models then
            for model in pairs(contract.models) do
                HashToModel[joaat(model)] = model
            end
        end
    end
end

local function normalizePlate(plate)
    return (plate or ''):gsub('^%s*(.-)%s*$', '%1'):upper()
end

local function getRep(Player)
    local rep = Player.PlayerData.metadata.rep or {}
    return tonumber(rep[Config.RepName] or rep[Config.LegacyRepName] or 0) or 0
end

local function getTier(rep)
    local tier = Config.ReputationTiers[1]
    for _, data in ipairs(Config.ReputationTiers) do
        if rep >= data.min then
            tier = data
        end
    end
    return tier
end

local function coordsToTable(coords)
    return {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        w = coords.w or 0.0,
    }
end

local function distanceTo(source, coords)
    local ped = GetPlayerPed(source)
    if ped == 0 then return 999999.0 end
    return #(GetEntityCoords(ped) - vector3(coords.x, coords.y, coords.z))
end

local function getVehicleFromNet(source, netId)
    if not netId then return nil, 'no_vehicle' end

    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if vehicle == 0 or not DoesEntityExist(vehicle) then return nil, 'no_vehicle' end

    local ped = GetPlayerPed(source)
    if GetPedInVehicleSeat(vehicle, -1) ~= ped then return nil, 'not_driver' end

    return vehicle
end

local function getVehicleClass(model)
    for className, classData in pairs(Config.VehicleClasses) do
        if classData.models[model] then
            return className, classData
        end
    end
end

local function contractAllowsVehicle(contract, model, className)
    if contract.models and not contract.models[model] then
        return false
    end

    if contract.classes and not contract.classes[className] then
        return false
    end

    return true
end

local function getContractPayload(id, contract)
    return {
        id = id,
        labelKey = contract.labelKey,
        descKey = contract.descKey,
        minRep = contract.minRep,
        basePay = contract.basePay,
        rep = contract.rep,
        timeLimit = contract.timeLimit,
        cargoUnits = contract.cargoUnits,
        pickup = coordsToTable(contract.pickup),
        dropoff = coordsToTable(contract.dropoff),
    }
end

local function fail(cb, message)
    cb({ ok = false, message = message })
end

local function validateJob(Player)
    return Player.PlayerData.job and Player.PlayerData.job.name == Config.RequiredJob
end

local function validateDepotDistance(source)
    for _, depot in ipairs(Config.Depots) do
        if distanceTo(source, depot.coords) <= Config.ActionDistance then
            return true
        end
    end
    return false
end

local function validateVehicleOwnership(Player, plate)
    return MySQL.single.await(
        'SELECT vehicle, plate FROM player_vehicles WHERE citizenid = ? AND plate = ?',
        { Player.PlayerData.citizenid, plate }
    )
end

local function validateAssignedVehicle(source, session, netId)
    local vehicle, err = getVehicleFromNet(source, netId)
    if not vehicle then return nil, err end

    local plate = normalizePlate(GetVehicleNumberPlateText(vehicle))
    if plate ~= session.plate then return nil, 'vehicle_changed' end

    local vehicleCoords = GetEntityCoords(vehicle)
    local pedCoords = GetEntityCoords(GetPlayerPed(source))
    if #(pedCoords - vehicleCoords) > Config.VehicleDistance then return nil, 'vehicle_too_far' end

    return vehicle
end

QBCore.Functions.CreateCallback('trucking:server:getStatus', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return fail(cb, 'no_active') end

    local rep = getRep(Player)
    local tier = getTier(rep)
    local contracts = {}

    for id, contract in pairs(Config.Contracts) do
        contracts[#contracts + 1] = getContractPayload(id, contract)
    end
    table.sort(contracts, function(a, b)
        if a.minRep == b.minRep then return a.basePay < b.basePay end
        return a.minRep < b.minRep
    end)

    cb({
        ok = true,
        rep = rep,
        tier = tier.name,
        tierLabelKey = tier.labelKey,
        contracts = contracts,
        active = ActiveContracts[source],
    })
end)

QBCore.Functions.CreateCallback('trucking:server:startContract', function(source, cb, contractId, netId)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return fail(cb, 'no_active') end
    if not validateJob(Player) then return fail(cb, 'not_trucker') end
    if ActiveContracts[source] then return fail(cb, 'already_active') end
    if not validateDepotDistance(source) then return fail(cb, 'too_far') end

    local now = os.time()
    if StartCooldowns[source] and now - StartCooldowns[source] < Config.StartCooldownSeconds then
        return fail(cb, 'cooldown')
    end

    local contract = Config.Contracts[contractId]
    if not contract then return fail(cb, 'contract_missing') end

    local rep = getRep(Player)
    if rep < contract.minRep then return fail(cb, 'contract_locked') end

    local vehicle, err = getVehicleFromNet(source, netId)
    if not vehicle then return fail(cb, err) end

    local model = HashToModel[GetEntityModel(vehicle)]
    if not model then return fail(cb, 'wrong_vehicle') end

    local className, classData = getVehicleClass(model)
    if not className or not contractAllowsVehicle(contract, model, className) then
        return fail(cb, 'wrong_vehicle')
    end

    local plate = normalizePlate(GetVehicleNumberPlateText(vehicle))
    local owned = validateVehicleOwnership(Player, plate)
    if not owned or owned.vehicle ~= model then return fail(cb, 'not_owned') end

    local tier = getTier(rep)
    ActiveContracts[source] = {
        contractId = contractId,
        status = 'accepted',
        plate = plate,
        model = model,
        className = className,
        classMultiplier = classData.multiplier,
        tierMultiplier = tier.multiplier,
        acceptedAt = now,
        loadedAt = 0,
        startBody = GetVehicleBodyHealth(vehicle),
        startEngine = GetVehicleEngineHealth(vehicle),
    }
    StartCooldowns[source] = now

    cb({
        ok = true,
        message = 'started',
        contract = getContractPayload(contractId, contract),
        plate = plate,
    })
end)

QBCore.Functions.CreateCallback('trucking:server:loadCargo', function(source, cb, netId)
    local session = ActiveContracts[source]
    if not session then return fail(cb, 'no_active') end
    if session.status ~= 'accepted' then return fail(cb, 'cargo_not_loaded') end

    local contract = Config.Contracts[session.contractId]
    if distanceTo(source, contract.pickup) > Config.ActionDistance then return fail(cb, 'too_far') end

    local vehicle, err = validateAssignedVehicle(source, session, netId)
    if not vehicle then return fail(cb, err) end

    session.status = 'loaded'
    session.loadedAt = os.time()
    session.startBody = GetVehicleBodyHealth(vehicle)
    session.startEngine = GetVehicleEngineHealth(vehicle)

    cb({
        ok = true,
        message = 'loaded',
        contract = getContractPayload(session.contractId, contract),
    })
end)

QBCore.Functions.CreateCallback('trucking:server:finishContract', function(source, cb, netId)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return fail(cb, 'no_active') end

    local session = ActiveContracts[source]
    if not session then return fail(cb, 'no_active') end
    if session.status ~= 'loaded' then return fail(cb, 'cargo_not_loaded') end

    local contract = Config.Contracts[session.contractId]
    if distanceTo(source, contract.dropoff) > Config.ActionDistance then return fail(cb, 'too_far') end

    local vehicle, err = validateAssignedVehicle(source, session, netId)
    if not vehicle then return fail(cb, err) end

    local bodyHealth = GetVehicleBodyHealth(vehicle)
    if bodyHealth < Config.MinimumFinishBodyHealth then return fail(cb, 'too_damaged') end

    local elapsedMinutes = math.max(1, math.ceil((os.time() - session.loadedAt) / 60))
    local damageTaken = math.max(0.0, session.startBody - bodyHealth)
    local damagePenalty = math.min(Config.MaxDamagePenalty, damageTaken / 1000.0)
    local latePenalty = 0.0
    if elapsedMinutes > contract.timeLimit then
        latePenalty = math.min(Config.MaxLatePenalty, (elapsedMinutes - contract.timeLimit) / contract.timeLimit)
    end

    local perfectBonus = 0.0
    if damageTaken <= 30.0 and elapsedMinutes <= contract.timeLimit then
        perfectBonus = Config.PerfectDeliveryBonus
    end

    local multiplier = session.classMultiplier * session.tierMultiplier
    local pay = math.floor(contract.basePay * multiplier * (1.0 - damagePenalty - latePenalty + perfectBonus))
    if pay < 0 then pay = 0 end

    Player.Functions.AddMoney(Config.PayAccount, pay, 'trucking-freight')
    Player.Functions.AddRep(Config.RepName, contract.rep)
    Player.Functions.AddRep(Config.LegacyRepName, contract.rep)

    local foundCrypto = false
    if math.random(100) <= Config.CryptostickChance then
        foundCrypto = exports['qb-inventory']:AddItem(source, 'cryptostick', 1, false, false, 'trucking:server:finishContract')
        if foundCrypto then
            TriggerClientEvent('qb-inventory:client:ItemBox', source, QBCore.Shared.Items['cryptostick'], 'add')
        end
    end

    ActiveContracts[source] = nil

    cb({
        ok = true,
        message = 'completed',
        pay = pay,
        rep = contract.rep,
        perfect = perfectBonus > 0,
        foundCrypto = foundCrypto,
    })
end)

QBCore.Functions.CreateCallback('trucking:server:cancelContract', function(source, cb)
    if not ActiveContracts[source] then return fail(cb, 'no_active') end
    ActiveContracts[source] = nil
    cb({ ok = true, message = 'route_cancelled' })
end)

AddEventHandler('playerDropped', function()
    ActiveContracts[source] = nil
    StartCooldowns[source] = nil
end)

exports('GetActiveContract', function(source)
    return ActiveContracts[source]
end)

exports('GetTierForRep', function(rep)
    return getTier(tonumber(rep) or 0)
end)

buildModelIndex()
