exports('AddProfessionXp', function(src, professionId, amount, reason)
    return Professions.AddProfessionXp(src, professionId, amount, reason)
end)

exports('GetProfessionLevel', function(src, professionId)
    return Professions.GetProfessionLevel(src, professionId)
end)

exports('GetProfessionProgress', function(src, professionId)
    return Professions.GetProfessionProgress(src, professionId)
end)

exports('GetPlayerProfessions', function(src)
    return Professions.GetPlayerProfessions(src)
end)

exports('GetMenuData', function(src)
    return Professions.GetMenuData(src)
end)

exports('ActivateProfession', function(src, professionId)
    return Professions.ActivateProfession(src, professionId)
end)

exports('UnlockProfessionSlot', function(src)
    return Professions.UnlockProfessionSlot(src)
end)

exports('SetProfessionSlots', function(src, slots, reason)
    return Professions.SetProfessionSlots(src, slots, reason)
end)

exports('DeactivateProfession', function(src, professionId)
    return Professions.DeactivateProfession(src, professionId)
end)

exports('ResetPlayerProfessions', function(src)
    return Professions.ResetPlayerProfessions(src)
end)

exports('AttemptGather', function(src, nodeId)
    return Professions.AttemptGather(src, nodeId)
end)

exports('AttemptCraft', function(src, recipeId)
    return Professions.AttemptCraft(src, recipeId)
end)
