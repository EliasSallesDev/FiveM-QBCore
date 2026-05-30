local QBCore
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
local ResetStress = false

QBCore.Commands.Add('cash', 'Check Cash Balance', {}, false, function(source, _)
    local Player = QBCore.Functions.GetPlayer(source)
    local cashamount = Player.PlayerData.money.cash
    TriggerClientEvent('hud:client:ShowAccounts', source, 'cash', cashamount)
end)

QBCore.Commands.Add('bank', 'Check Bank Balance', {}, false, function(source, _)
    local Player = QBCore.Functions.GetPlayer(source)
    local bankamount = Player.PlayerData.money.bank
    TriggerClientEvent('hud:client:ShowAccounts', source, 'bank', bankamount)
end)

QBCore.Commands.Add('dev', 'Enable/Disable developer Mode', {}, false, function(source, _)
    TriggerClientEvent('qb-admin:client:ToggleDevmode', source)
end, 'admin')

RegisterNetEvent('hud:server:GainStress', function(amount)
    if Config.DisableStress then return end

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not Player.PlayerData then return end

    local Job = Player.PlayerData.job and Player.PlayerData.job.name or 'unemployed'
    local JobType = Player.PlayerData.job and Player.PlayerData.job.type or 'none'

    if Config.WhitelistedJobs[JobType] or Config.WhitelistedJobs[Job] then return end

    if not Player.PlayerData.metadata then
        Player.PlayerData.metadata = {}
    end

    local newStress = 0

    if not ResetStress then
        local currentStress = Player.PlayerData.metadata['stress'] or 0
        newStress = currentStress + amount
        if newStress <= 0 then newStress = 0 end
    end

    if newStress > 100 then
        newStress = 100
    end

    Player.Functions.SetMetaData('stress', newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('notify.stress_gain'), 'error', 1500)
end)

RegisterNetEvent('hud:server:RelieveStress', function(amount)
    if Config.DisableStress then return end

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not Player.PlayerData then return end

    if not Player.PlayerData.metadata then
        Player.PlayerData.metadata = {}
    end

    local newStress = 0

    if not ResetStress then
        local currentStress = Player.PlayerData.metadata['stress'] or 0
        newStress = currentStress - amount
        if newStress <= 0 then newStress = 0 end
    end

    if newStress > 100 then
        newStress = 100
    end

    Player.Functions.SetMetaData('stress', newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('notify.stress_removed'))
end)

QBCore.Functions.CreateCallback('hud:server:getMenu', function(_, cb)
    cb(Config.Menu)
end)
