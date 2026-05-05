local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qbx-professions:server:getProfessions', function(source, cb)
    cb(Professions.GetPlayerProfessions(source))
end)

QBCore.Functions.CreateCallback('qbx-professions:server:getMenuData', function(source, cb)
    cb(Professions.GetMenuData(source))
end)

QBCore.Functions.CreateCallback('qbx-professions:server:getProfession', function(source, cb, professionId)
    cb(Professions.GetProfessionProgress(source, professionId))
end)

QBCore.Functions.CreateCallback('qbx-professions:server:activateProfession', function(source, cb, professionId)
    local ok, result = Professions.ActivateProfession(source, professionId)

    cb(ok, result)
end)

QBCore.Functions.CreateCallback('qbx-professions:server:gather', function(source, cb, nodeId)
    local ok, result, remaining = Professions.AttemptGather(source, nodeId)

    cb(ok, result, remaining)
end)

QBCore.Functions.CreateCallback('qbx-professions:server:craft', function(source, cb, recipeId)
    local ok, result = Professions.AttemptCraft(source, recipeId)

    cb(ok, result)
end)
