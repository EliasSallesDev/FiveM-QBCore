exports('GrantCharacterXp', function(src, amount, reason)
    return Progression.GrantCharacterXp(src, amount, reason)
end)

exports('GetCharacterProgress', function(src)
    return Progression.GetCharacterProgress(src)
end)
