exports('TryAllocateNode', function(src, treeId, nodeId)
    return SkillTree.TryAllocateNode(src, treeId, nodeId)
end)

exports('GetAllocatedNodes', function(citizenid)
    return SkillTree.GetAllocatedNodes(citizenid)
end)

exports('GetMenuData', function(src)
    return SkillTree.GetMenuData(src)
end)

exports('GetSkillModifiers', function(src)
    return SkillTree.GetSkillModifiers(src)
end)

exports('GetAbilityRanks', function(src)
    return SkillTree.GetAbilityRanks(src)
end)

exports('RespecPlayer', function(src, consumeItem)
    return SkillTree.RespecPlayer(src, consumeItem == true)
end)
