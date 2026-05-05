local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qbx-skilltree:server:getMenuData', function(source, cb)
    cb(SkillTree.GetMenuData(source))
end)

QBCore.Functions.CreateCallback('qbx-skilltree:server:allocateNode', function(source, cb, treeId, nodeId)
    local ok, result, detail = SkillTree.TryAllocateNode(source, treeId, nodeId)

    cb(ok, result, detail)
end)

QBCore.Functions.CreateCallback('qbx-skilltree:server:respec', function(source, cb)
    local ok, result = SkillTree.RespecPlayer(source, true)

    cb(ok, result)
end)
