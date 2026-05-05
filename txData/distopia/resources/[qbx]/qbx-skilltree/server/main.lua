local QBCore = exports['qb-core']:GetCoreObject()

local playerLocks = {}

local function getPlayer(src)
    if not src then
        return nil
    end

    return QBCore.Functions.GetPlayer(src)
end

local function withPlayerLock(src, action)
    if playerLocks[src] then
        return false, 'action_in_progress'
    end

    playerLocks[src] = true

    local protected = { pcall(action) }
    playerLocks[src] = nil

    if not protected[1] then
        print(('[qbx-skilltree] action failed for %s: %s'):format(src, protected[2]))
        return false, 'internal_error'
    end

    return protected[2], protected[3], protected[4]
end

local function ensureRespecItemDefinition()
    local item = Config.RespecItem

    if not item or not item.enabled or not item.item or not QBCore.Shared or not QBCore.Shared.Items then
        return
    end

    if QBCore.Shared.Items[item.item] then
        return
    end

    QBCore.Shared.Items[item.item] = {
        name = item.item,
        label = item.label or item.item,
        weight = item.weight or 0,
        type = 'item',
        image = item.image or 'certificate.png',
        unique = false,
        useable = true,
        shouldClose = true,
        description = item.description or 'Reseta a arvore de habilidades.',
    }
end

local function getInventoryResource()
    return (Config.Inventory and Config.Inventory.resource) or 'qb-inventory'
end

local function hasItem(src, item, amount)
    amount = math.max(math.floor(tonumber(amount) or 1), 1)

    if not item or item == '' then
        return true
    end

    local inventory = getInventoryResource()

    if GetResourceState(inventory) ~= 'started' then
        return false, 'inventory_unavailable'
    end

    if inventory == 'qb-inventory' then
        return exports['qb-inventory']:HasItem(src, item, amount) == true
    end

    if inventory == 'ox_inventory' then
        return (tonumber(exports['ox_inventory']:Search(src, 'count', item)) or 0) >= amount
    end

    return false, 'inventory_unavailable'
end

local function removeItem(src, item, amount, reason)
    amount = math.max(math.floor(tonumber(amount) or 1), 1)

    local inventory = getInventoryResource()

    if GetResourceState(inventory) ~= 'started' then
        return false, 'inventory_unavailable'
    end

    if inventory == 'qb-inventory' then
        return exports['qb-inventory']:RemoveItem(src, item, amount, false, reason) == true
    end

    if inventory == 'ox_inventory' then
        return exports['ox_inventory']:RemoveItem(src, item, amount) == true
    end

    return false, 'inventory_unavailable'
end

local function addItem(src, item, amount, reason)
    amount = math.max(math.floor(tonumber(amount) or 1), 1)

    local inventory = getInventoryResource()

    if GetResourceState(inventory) ~= 'started' then
        return false, 'inventory_unavailable'
    end

    if inventory == 'qb-inventory' then
        return exports['qb-inventory']:AddItem(src, item, amount, false, false, reason) == true
    end

    if inventory == 'ox_inventory' then
        return exports['ox_inventory']:AddItem(src, item, amount) == true
    end

    return false, 'inventory_unavailable'
end

local function getCharacterProgress(player)
    local metadata = player.PlayerData.metadata or {}
    local progress = metadata.character

    if type(progress) ~= 'table' then
        progress = {
            level = 1,
            xp = 0,
            skillPoints = 0,
            statAlloc = {},
        }
    end

    progress.level = math.max(math.floor(tonumber(progress.level) or 1), 1)
    progress.xp = math.max(math.floor(tonumber(progress.xp) or 0), 0)
    progress.skillPoints = math.max(math.floor(tonumber(progress.skillPoints) or 0), 0)
    progress.statAlloc = type(progress.statAlloc) == 'table' and progress.statAlloc or {}

    return progress
end

local function setCharacterProgress(player, progress)
    player.Functions.SetMetaData('character', progress)
end

local function allocatedMap(rows)
    local map = {}

    for _, row in ipairs(rows or {}) do
        map[row.tree_id] = map[row.tree_id] or {}
        map[row.tree_id][row.node_id] = math.max(math.floor(tonumber(row.rank) or 1), 1)
    end

    return map
end

local function parseRequirement(requirement)
    if type(requirement) ~= 'string' then
        return nil, nil
    end

    local nodeId, rank = requirement:match('^([^:]+):rank(%d+)$')

    if not nodeId then
        return requirement, 1
    end

    return nodeId, math.max(math.floor(tonumber(rank) or 1), 1)
end

local function hasRequiredClass(src, tree)
    if type(tree) ~= 'table' or not tree.class then
        return true
    end

    if GetResourceState('qbx-classes') ~= 'started' then
        return false
    end

    return exports['qbx-classes']:GetClassId(src) == tree.class
end

local function prereqsMet(tree, map, node)
    for _, requirement in ipairs(node.requires or {}) do
        local requiredNodeId, requiredRank = parseRequirement(requirement)

        if not requiredNodeId or (map[requiredNodeId] or 0) < requiredRank then
            return false, requirement
        end
    end

    return true
end

local function nodeCostAtNextRank(node, currentRank)
    local nextRank = (math.floor(tonumber(currentRank) or 0) + 1)

    if nextRank > SkillTree.GetMaxRank(node) then
        return nil, 'node_max_rank'
    end

    return SkillTree.GetNodeCost(node, nextRank), nil, nextRank
end

local function buildTreePayload(treeId, allocated)
    local tree = SkillTree.GetTreeDefinition(treeId)

    if not tree then
        return nil
    end

    tree.allocated = allocated[treeId] or {}

    return tree
end

function SkillTree.GetAllocatedNodes(citizenid)
    return SkillTree.FetchAllocatedNodes(citizenid)
end

function SkillTree.GetAllocatedMap(citizenid)
    return allocatedMap(SkillTree.FetchAllocatedNodes(citizenid))
end

function SkillTree.GetMenuData(src)
    local player = getPlayer(src)

    if not player then
        return nil
    end

    local progress = getCharacterProgress(player)
    local allocated = SkillTree.GetAllocatedMap(player.PlayerData.citizenid)
    local trees = {}

    for treeId in pairs(Config.Trees) do
        trees[#trees + 1] = buildTreePayload(treeId, allocated)
    end

    table.sort(trees, function(left, right)
        if left.category == right.category then
            return left.label < right.label
        end

        return left.category < right.category
    end)

    return {
        skillPoints = progress.skillPoints,
        trees = trees,
        activeClass = GetResourceState('qbx-classes') == 'started' and exports['qbx-classes']:GetClassId(src) or nil,
        respecTax = Config.RespecTax,
    }
end

function SkillTree.GetSkillModifiers(src)
    local player = getPlayer(src)

    if not player then
        return nil
    end

    local activeClass = GetResourceState('qbx-classes') == 'started' and exports['qbx-classes']:GetClassId(src) or nil
    local rows = SkillTree.FetchAllocatedNodes(player.PlayerData.citizenid)
    local modifiers = {}

    for _, row in ipairs(rows) do
        local tree = Config.Trees[row.tree_id]
        local node = tree and tree.nodes[row.node_id]
        local treeApplies = tree and (not tree.class or tree.class == activeClass)

        if treeApplies and node and type(node.effects) == 'table' then
            local rank = math.max(math.floor(tonumber(row.rank) or 1), 1)

            for key, value in pairs(node.effects) do
                modifiers[key] = (modifiers[key] or 0) + ((tonumber(value) or 0) * rank)
            end
        end
    end

    return modifiers
end

function SkillTree.GetAbilityRanks(src)
    local player = getPlayer(src)

    if not player then
        return nil
    end

    local activeClass = GetResourceState('qbx-classes') == 'started' and exports['qbx-classes']:GetClassId(src) or nil
    local rows = SkillTree.FetchAllocatedNodes(player.PlayerData.citizenid)
    local abilities = {}

    for _, row in ipairs(rows) do
        local tree = Config.Trees[row.tree_id]
        local node = tree and tree.nodes[row.node_id]
        local treeApplies = tree and (not tree.class or tree.class == activeClass)

        if treeApplies and node and node.type == 'active' and node.ability then
            abilities[node.ability] = math.max(abilities[node.ability] or 0, math.floor(tonumber(row.rank) or 1))
        end
    end

    return abilities
end

function SkillTree.TryAllocateNode(src, treeId, nodeId)
    return withPlayerLock(src, function()
        local player = getPlayer(src)

        if not player then
            return false, 'invalid_player'
        end

        if not SkillTree.IsValidNode(treeId, nodeId) then
            return false, 'invalid_node'
        end

        local tree = Config.Trees[treeId]

        if not hasRequiredClass(src, tree) then
            return false, 'class_required'
        end

        local node = tree.nodes[nodeId]
        local allocated = SkillTree.GetAllocatedMap(player.PlayerData.citizenid)
        local treeMap = allocated[treeId] or {}
        local prereqOk, missing = prereqsMet(tree, treeMap, node)

        if not prereqOk then
            return false, 'prereq_required', missing
        end

        local currentRank = treeMap[nodeId] or 0
        local cost, costErr, nextRank = nodeCostAtNextRank(node, currentRank)

        if costErr then
            return false, costErr
        end

        local progress = getCharacterProgress(player)

        if progress.skillPoints < cost then
            return false, 'not_enough_points'
        end

        if not SkillTree.UpsertAllocatedNode(player.PlayerData.citizenid, treeId, nodeId, nextRank) then
            return false, 'db_error'
        end

        progress.skillPoints = progress.skillPoints - cost
        setCharacterProgress(player, progress)

        local result = SkillTree.GetMenuData(src)
        result.allocatedNode = {
            treeId = treeId,
            nodeId = nodeId,
            rank = nextRank,
            cost = cost,
        }

        if Config.NotifyAllocate then
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.node_allocated', {
                node = node.label or nodeId,
                rank = nextRank,
            }), 'success')
        end

        TriggerClientEvent('qbx-skilltree:client:skillTreeUpdated', src, result)
        TriggerEvent('qbx-skilltree:server:nodeAllocated', src, result.allocatedNode, result)

        return true, result
    end)
end

function SkillTree.RespecPlayer(src, consumeItem)
    return withPlayerLock(src, function()
        local player = getPlayer(src)

        if not player then
            return false, 'invalid_player'
        end

        local rows = SkillTree.FetchAllocatedNodes(player.PlayerData.citizenid)

        if #rows == 0 then
            return false, 'no_nodes_allocated'
        end

        local item = Config.RespecItem
        local removedItem = nil

        if consumeItem and item and item.enabled then
            local hasToken, hasErr = hasItem(src, item.item, item.amount)

            if not hasToken then
                return false, hasErr or 'respec_item_required'
            end

            local removed, removeErr = removeItem(src, item.item, item.amount, 'qbx-skilltree:respec')

            if not removed then
                return false, removeErr or 'respec_item_required'
            end

            removedItem = {
                item = item.item,
                amount = item.amount,
            }
        end

        local spent = 0

        for _, row in ipairs(rows) do
            local tree = Config.Trees[row.tree_id]
            local node = tree and tree.nodes[row.node_id]
            local rank = math.max(math.floor(tonumber(row.rank) or 0), 0)

            for index = 1, rank do
                spent = spent + (SkillTree.GetNodeCost(node, index) or 0)
            end
        end

        local deleted = SkillTree.DeleteAllocatedNodes(player.PlayerData.citizenid)

        if deleted == false then
            if removedItem then
                addItem(src, removedItem.item, removedItem.amount, 'qbx-skilltree:respec-rollback')
            end

            return false, 'db_error'
        end

        local tax = math.min(math.floor(spent * Config.RespecTax + 0.5), Config.MaxRefundTaxPoints)
        local refund = math.max(spent - tax, 0)
        local progress = getCharacterProgress(player)
        progress.skillPoints = progress.skillPoints + refund
        setCharacterProgress(player, progress)

        local result = SkillTree.GetMenuData(src)
        result.respec = {
            spent = spent,
            refund = refund,
            tax = tax,
        }

        TriggerClientEvent('qbx-skilltree:client:skillTreeUpdated', src, result)
        TriggerEvent('qbx-skilltree:server:respec', src, result.respec, result)

        return true, result
    end)
end

ensureRespecItemDefinition()

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    ensureRespecItemDefinition()
    SkillTree.EnsureSchema()

    local item = Config.RespecItem

    if item and item.enabled and QBCore.Functions.CreateUseableItem then
        QBCore.Functions.CreateUseableItem(item.item, function(source)
            local ok, result = SkillTree.RespecPlayer(source, true)

            if not ok then
                TriggerClientEvent('QBCore:Notify', source, Lang:t('error.' .. result), 'error')
                return
            end

            TriggerClientEvent('QBCore:Notify', source, Lang:t('success.respec', {
                points = result.respec.refund,
                tax = result.respec.tax,
            }), 'success')
        end)
    end
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    playerLocks[src] = nil
end)
