SkillTree = SkillTree or {}

local function copyTable(value)
    if type(value) ~= 'table' then
        return value
    end

    local copy = {}

    for key, item in pairs(value) do
        copy[key] = copyTable(item)
    end

    return copy
end

function SkillTree.CopyTable(value)
    return copyTable(value)
end

function SkillTree.IsValidTree(treeId)
    return type(treeId) == 'string'
        and Config.Trees[treeId] ~= nil
        and type(Config.Trees[treeId].nodes) == 'table'
end

function SkillTree.IsValidNode(treeId, nodeId)
    return SkillTree.IsValidTree(treeId)
        and type(nodeId) == 'string'
        and Config.Trees[treeId].nodes[nodeId] ~= nil
end

function SkillTree.GetTreeDefinition(treeId)
    if not SkillTree.IsValidTree(treeId) then
        return nil
    end

    local tree = copyTable(Config.Trees[treeId])
    tree.id = treeId

    return tree
end

function SkillTree.GetNodeDefinition(treeId, nodeId)
    if not SkillTree.IsValidNode(treeId, nodeId) then
        return nil
    end

    local node = copyTable(Config.Trees[treeId].nodes[nodeId])
    node.id = nodeId

    return node
end

function SkillTree.GetNodeCost(node, rank)
    rank = math.max(math.floor(tonumber(rank) or 1), 1)

    if type(node) ~= 'table' then
        return nil
    end

    if type(node.costPerRank) == 'table' then
        return math.max(math.floor(tonumber(node.costPerRank[rank]) or 0), 0)
    end

    return math.max(math.floor(tonumber(node.cost) or 1), 0)
end

function SkillTree.GetMaxRank(node)
    return math.max(math.floor(tonumber(node and node.maxRank) or 1), 1)
end
