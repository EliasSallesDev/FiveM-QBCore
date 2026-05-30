-- Variables
QBCore = exports['qb-core']:GetCoreObject()
local updatingCops = false

-- Functions

local function IsDutyEmergencyPlayer(player, includeEms)
    if not player or not player.PlayerData or not player.PlayerData.job then return false end

    local job = player.PlayerData.job
    if not job.onduty then return false end
    if job.type == 'leo' then return true end
    return includeEms and job.type == 'ems'
end

local function IsPolicePlayer(player)
    return player and player.PlayerData and player.PlayerData.job and player.PlayerData.job.type == 'leo'
end

local function GetPlayerCallsign(player)
    return player.PlayerData.metadata and player.PlayerData.metadata['callsign'] or ''
end

local function GetOnlinePlayers()
    if not QBCore or not QBCore.Functions or not QBCore.Functions.GetQBPlayers then return {} end

    local ok, players = pcall(QBCore.Functions.GetQBPlayers)
    if not ok or type(players) ~= 'table' then return {} end

    return players
end

local function UpdateBlips()
    local dutyPlayers = {}
    local players = GetOnlinePlayers()
    for _, v in pairs(players) do
        if IsDutyEmergencyPlayer(v, true) then
            local source = tonumber(v.PlayerData.source)
            local ped = source and GetPlayerPed(source)
            if source and ped and ped ~= 0 then
                local coordsOk, coords = pcall(GetEntityCoords, ped)
                local headingOk, heading = pcall(GetEntityHeading, ped)
                if coordsOk and headingOk and coords then
                    dutyPlayers[#dutyPlayers + 1] = {
                        source = source,
                        label = GetPlayerCallsign(v),
                        job = v.PlayerData.job.name,
                        location = {
                            x = coords.x,
                            y = coords.y,
                            z = coords.z,
                            w = heading
                        }
                    }
                end
            end
        end
    end
    TriggerClientEvent('police:client:UpdateBlips', -1, dutyPlayers)
end

local function SafeUpdateBlips()
    local ok, err = pcall(UpdateBlips)
    if not ok then
        print(('[qb-policejob] UpdateBlips skipped: %s'):format(err))
    end
end

local function GetCurrentCops()
    local amount = 0
    local players = GetOnlinePlayers()
    for _, v in pairs(players) do
        if IsDutyEmergencyPlayer(v, false) then
            amount += 1
        end
    end
    return amount
end

local function GetDutyPolice()
    local dutyPlayers = {}
    local players = GetOnlinePlayers()
    for _, v in pairs(players) do
        if IsDutyEmergencyPlayer(v, false) then
            local source = tonumber(v.PlayerData.source)
            if source then
                dutyPlayers[#dutyPlayers + 1] = {
                    source = source,
                    label = GetPlayerCallsign(v),
                    job = v.PlayerData.job.name
                }
            end
        end
    end
    return dutyPlayers
end

-- Callbacks

QBCore.Functions.CreateCallback('police:GetDutyPlayers', function(_, cb)
    cb(GetDutyPolice())
end)

QBCore.Functions.CreateCallback('police:GetCops', function(_, cb)
    cb(GetCurrentCops())
end)

QBCore.Functions.CreateCallback('police:server:isPlayerDead', function(_, cb, playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    cb(Player and Player.PlayerData.metadata['isdead'] or false)
end)

QBCore.Functions.CreateCallback('police:IsSilencedWeapon', function(source, cb, weapon)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player or not QBCore.Shared.Weapons[weapon] then
        cb(false)
        return
    end

    local itemInfo = Player.Functions.GetItemByName(QBCore.Shared.Weapons[weapon]['name'])
    local retval = false
    if itemInfo then
        if itemInfo.info and itemInfo.info.attachments then
            for k in pairs(itemInfo.info.attachments) do
                if itemInfo.info.attachments[k].component == 'COMPONENT_AT_AR_SUPP_02' or
                    itemInfo.info.attachments[k].component == 'COMPONENT_AT_AR_SUPP' or
                    itemInfo.info.attachments[k].component == 'COMPONENT_AT_PI_SUPP_02' or
                    itemInfo.info.attachments[k].component == 'COMPONENT_AT_PI_SUPP' then
                    retval = true
                end
            end
        end
    end
    cb(retval)
end)

QBCore.Functions.CreateCallback('police:server:IsPoliceForcePresent', function(_, cb)
    local retval = false
    local players = GetOnlinePlayers()
    for _, v in pairs(players) do
        if IsPolicePlayer(v) and v.PlayerData.job.grade and v.PlayerData.job.grade.level >= 2 then
            retval = true
            break
        end
    end
    cb(retval)
end)

-- Events

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CreateThread(function()
            MySQL.query("DELETE FROM inventories WHERE identifier = 'policetrash'")
        end)
    end
end)

RegisterNetEvent('qb-policejob:server:stash', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not IsPolicePlayer(Player) then return end
    local citizenId = Player.PlayerData.citizenid
    local stashName = 'policestash_' .. citizenId
    exports['qb-inventory']:OpenInventory(src, stashName)
end)

RegisterNetEvent('qb-policejob:server:trash', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not IsPolicePlayer(Player) then return end
    exports['qb-inventory']:OpenInventory(src, 'policetrash', {
        maxweight = 4000000,
        slots = 300,
    })
end)

RegisterNetEvent('qb-policejob:server:evidence', function(currentEvidence)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not IsPolicePlayer(Player) then return end
    exports['qb-inventory']:OpenInventory(src, currentEvidence, {
        maxweight = 4000000,
        slots = 500,
    })
end)

RegisterNetEvent('police:server:policeAlert', function(text)
    local src = source
    local ped = GetPlayerPed(src)
    if ped == 0 then return end
    local coords = GetEntityCoords(ped)
    local players = GetOnlinePlayers()
    for _, v in pairs(players) do
        if IsDutyEmergencyPlayer(v, false) then
            local alertData = { title = Lang:t('info.new_call'), coords = { x = coords.x, y = coords.y, z = coords.z }, description = text }
            TriggerClientEvent('qb-phone:client:addPoliceAlert', v.PlayerData.source, alertData)
            TriggerClientEvent('police:client:policeAlert', v.PlayerData.source, coords, text)
        end
    end
end)

RegisterNetEvent('police:server:UpdateCurrentCops', function()
    if updatingCops then return end
    updatingCops = true
    TriggerClientEvent('police:SetCopCount', -1, GetCurrentCops())
    updatingCops = false
end)

RegisterNetEvent('police:server:SetHandcuffStatus', function(isHandcuffed)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.SetMetaData('ishandcuffed', isHandcuffed)
    end
end)

RegisterNetEvent('police:server:showFingerprint', function(playerId)
    local src = source
    TriggerClientEvent('police:client:showFingerprint', playerId, src)
    TriggerClientEvent('police:client:showFingerprint', src, playerId)
end)

RegisterNetEvent('police:server:showFingerprintId', function(sessionId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local fid = Player.PlayerData.metadata['fingerprint']
    TriggerClientEvent('police:client:showFingerprintId', sessionId, fid)
    TriggerClientEvent('police:client:showFingerprintId', src, fid)
end)

RegisterNetEvent('police:server:SetTracker', function(targetId)
    local src = source
    local playerPed = GetPlayerPed(src)
    local targetPed = GetPlayerPed(targetId)
    if playerPed == 0 or targetPed == 0 then return end
    local playerCoords = GetEntityCoords(playerPed)
    local targetCoords = GetEntityCoords(targetPed)
    if #(playerCoords - targetCoords) > 2.5 then return DropPlayer(src, 'Attempted exploit abuse') end

    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(targetId)
    if not Player or not Target then return end

    local TrackerMeta = Target.PlayerData.metadata['tracker']
    if TrackerMeta then
        Target.Functions.SetMetaData('tracker', false)
        TriggerClientEvent('QBCore:Notify', targetId, Lang:t('success.anklet_taken_off'), 'success')
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.took_anklet_from', { firstname = Target.PlayerData.charinfo.firstname, lastname = Target.PlayerData.charinfo.lastname }), 'success')
        TriggerClientEvent('police:client:SetTracker', targetId, false)
    else
        Target.Functions.SetMetaData('tracker', true)
        TriggerClientEvent('QBCore:Notify', targetId, Lang:t('success.put_anklet'), 'success')
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.put_anklet_on', { firstname = Target.PlayerData.charinfo.firstname, lastname = Target.PlayerData.charinfo.lastname }), 'success')
        TriggerClientEvent('police:client:SetTracker', targetId, true)
    end
end)

RegisterNetEvent('police:server:SendTrackerLocation', function(coords, requestId)
    local Target = QBCore.Functions.GetPlayer(source)
    if not Target then return end
    local msg = Lang:t('info.target_location', { firstname = Target.PlayerData.charinfo.firstname, lastname = Target.PlayerData.charinfo.lastname })
    local alertData = {
        title = Lang:t('info.anklet_location'),
        coords = {
            x = coords.x,
            y = coords.y,
            z = coords.z
        },
        description = msg
    }
    TriggerClientEvent('police:client:TrackerMessage', requestId, msg, coords)
    TriggerClientEvent('qb-phone:client:addPoliceAlert', requestId, alertData)
end)

-- Threads

CreateThread(function()
    while true do
        Wait(1000 * 60 * 10)
        local curCops = GetCurrentCops()
        TriggerClientEvent('police:SetCopCount', -1, curCops)
    end
end)

CreateThread(function()
    while true do
        Wait(5000)
        SafeUpdateBlips()
    end
end)

-- Items

QBCore.Functions.CreateUseableItem('handcuffs', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not Player.Functions.GetItemByName('handcuffs') then return end
    TriggerClientEvent('police:client:CuffPlayerSoft', src)
end)

QBCore.Functions.CreateUseableItem('moneybag', function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not item or not Player.Functions.GetItemByName('moneybag') or not item.info or item.info == '' then return end
    if not IsPolicePlayer(Player) then return end
    if not exports['qb-inventory']:RemoveItem(src, 'moneybag', 1, item.slot, 'qb-policejob:moneybag') then return end
    Player.Functions.AddMoney('cash', tonumber(item.info.cash), 'qb-policejob:moneybag')
end)
