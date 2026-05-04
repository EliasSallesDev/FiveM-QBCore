local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qbx-progression:server:getProgress', function(source, cb)
    cb(Progression.GetCharacterProgress(source))
end)
