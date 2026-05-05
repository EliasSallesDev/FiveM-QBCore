local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qbx-classes:server:getClass', function(source, cb)
    cb(Classes.GetPlayerClass(source))
end)

QBCore.Functions.CreateCallback('qbx-classes:server:getModifiers', function(source, cb)
    cb(Classes.GetClassModifiers(source))
end)

QBCore.Functions.CreateCallback('qbx-classes:server:getMenuData', function(source, cb)
    cb(Classes.GetClassMenuData(source))
end)

QBCore.Functions.CreateCallback('qbx-classes:server:changeClass', function(source, cb, classId)
    local ok, result, remaining = Classes.SetPlayerClass(source, classId, false)

    cb(ok, result, remaining)
end)

QBCore.Functions.CreateCallback('qbx-classes:server:tryUseAbility', function(source, cb, abilityId)
    local ok, result, remaining = Classes.TryUseAbility(source, abilityId)

    cb(ok, result, remaining)
end)
