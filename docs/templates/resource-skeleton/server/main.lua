local QBCore = exports['qb-core']:GetCoreObject()

-- Server entry: load exports, register handlers, optional threads.

AddEventHandler('QBCore:Server:PlayerLoaded', function(player)
    -- local src = player.PlayerData.source
    -- Init per-player state or load from DB
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    -- Teardown
end)
