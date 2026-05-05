exports('GetClassId', function(src)
    return Classes.GetClassId(src)
end)

exports('GetClassModifiers', function(src)
    return Classes.GetClassModifiers(src)
end)

exports('GetClassData', function(src)
    return Classes.GetPlayerClass(src)
end)

exports('SetPlayerClass', function(src, classId, force)
    return Classes.SetPlayerClass(src, classId, force == true)
end)

exports('GrantClassXp', function(src, amount, reason)
    return Classes.GrantClassXp(src, amount, reason)
end)

exports('TryUseAbility', function(src, abilityId)
    return Classes.TryUseAbility(src, abilityId)
end)
