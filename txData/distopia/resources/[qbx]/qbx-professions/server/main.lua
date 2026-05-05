local QBCore = exports['qb-core']:GetCoreObject()

local grantBuckets = {}
local gatherCooldowns = {}

local function ensureProfessionSlotItemDefinition()
    local item = Config.ProfessionSlotItem

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
        description = item.description or 'Desbloqueia uma profissão ativa adicional.',
    }
end

ensureProfessionSlotItemDefinition()

local function getPlayer(src)
    if not src then
        return nil
    end

    return QBCore.Functions.GetPlayer(src)
end

local function copyDefaultProgress()
    return Professions.DefaultProgress()
end

local function normalizeProgress(progress)
    local normalized = copyDefaultProgress()
    local changed = type(progress) ~= 'table'

    if type(progress) == 'table' then
        normalized.xp = math.max(math.floor(tonumber(progress.xp) or normalized.xp), 0)
        normalized.level = math.max(math.floor(tonumber(progress.level) or normalized.level), 1)

        changed = changed
            or progress.xp ~= normalized.xp
            or progress.level ~= normalized.level
    end

    if Config.MaxProfessionLevel > 0 and normalized.level > Config.MaxProfessionLevel then
        normalized.level = Config.MaxProfessionLevel
        normalized.xp = 0
        changed = true
    end

    return normalized, changed
end

local function normalizeProfessionsData(professionsData)
    local normalized = {}
    local changed = type(professionsData) ~= 'table'

    for professionId in pairs(Config.Professions) do
        local progress, progressChanged = normalizeProgress(type(professionsData) == 'table' and professionsData[professionId] or nil)
        normalized[professionId] = progress
        changed = changed or progressChanged
    end

    return normalized, changed
end

local function setProfessionsData(player, professionsData)
    player.Functions.SetMetaData('professions', professionsData)
end

local function normalizeProfessionState(state, professionsData)
    local normalized = {
        active = {},
        unlockedSlots = math.max(math.floor(tonumber(Config.DefaultActiveProfessionSlots) or 1), 1),
    }
    local changed = type(state) ~= 'table'

    if type(state) == 'table' then
        normalized.unlockedSlots = math.max(math.floor(tonumber(state.unlockedSlots) or normalized.unlockedSlots), 1)

        if type(state.active) == 'table' then
            for _, professionId in ipairs(state.active) do
                if Professions.IsValidProfession(professionId) and not normalized.active[professionId] then
                    normalized.active[#normalized.active + 1] = professionId
                    normalized.active[professionId] = true
                else
                    changed = true
                end
            end
        else
            changed = true
        end
    end

    normalized.unlockedSlots = math.min(normalized.unlockedSlots, Config.MaxActiveProfessionSlots)

    while #normalized.active > normalized.unlockedSlots do
        normalized.active[normalized.active[#normalized.active]] = nil
        normalized.active[#normalized.active] = nil
        changed = true
    end

    for key, value in pairs(normalized.active) do
        if type(key) ~= 'number' or type(value) ~= 'string' then
            normalized.active[key] = nil
        end
    end

    return normalized, changed
end

local function setProfessionState(player, state)
    player.Functions.SetMetaData('professionState', state)
end

local function isAllowedReason(reason)
    return type(reason) == 'string'
        and reason ~= ''
        and #reason <= 64
        and Config.AllowedReasons[reason] == true
end

local function isRateLimited(src, reason, consume)
    local rule = Config.RateLimits[reason] or Config.RateLimits.default

    if not rule then
        return false
    end

    if consume == nil then
        consume = true
    end

    local now = os.time()
    local key = ('%s:%s'):format(src, reason)
    local bucket = grantBuckets[key]

    if not bucket or now - bucket.startedAt >= rule.window then
        if consume then
            grantBuckets[key] = {
                startedAt = now,
                count = 1,
            }
        end

        return false
    end

    if not consume then
        return bucket.count + 1 > rule.max
    end

    bucket.count = bucket.count + 1
    return bucket.count > rule.max
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

local function getItemCount(src, item)
    if not item or item == '' then
        return 0
    end

    local inventory = getInventoryResource()

    if GetResourceState(inventory) ~= 'started' then
        return 0
    end

    if inventory == 'qb-inventory' then
        return tonumber(exports['qb-inventory']:GetItemCount(src, item)) or 0
    end

    if inventory == 'ox_inventory' then
        return tonumber(exports['ox_inventory']:Search(src, 'count', item)) or 0
    end

    return 0
end

local function canAddItem(src, item, amount)
    amount = math.max(math.floor(tonumber(amount) or 1), 1)

    local inventory = getInventoryResource()

    if GetResourceState(inventory) ~= 'started' then
        return false, 'inventory_unavailable'
    end

    if inventory == 'qb-inventory' then
        local ok, err = exports['qb-inventory']:CanAddItem(src, item, amount)
        return ok == true, err
    end

    if inventory == 'ox_inventory' then
        return exports['ox_inventory']:CanCarryItem(src, item, amount) == true
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

local function addItems(src, items, reason)
    local added = {}

    for _, item in ipairs(items or {}) do
        local ok, err = addItem(src, item.item, item.amount, reason)

        if not ok then
            for index = #added, 1, -1 do
                removeItem(src, added[index].item, added[index].amount, reason .. ':rollback')
            end

            return false, err or 'inventory_add_failed'
        end

        added[#added + 1] = item
    end

    return true, added
end

local function removeItems(src, items, reason)
    local removed = {}

    for _, item in ipairs(items or {}) do
        local ok, err = removeItem(src, item.item, item.amount, reason)

        if not ok then
            for index = #removed, 1, -1 do
                addItem(src, removed[index].item, removed[index].amount, reason .. ':rollback')
            end

            return false, err or 'missing_ingredients'
        end

        removed[#removed + 1] = item
    end

    return true, removed
end

local function rollbackAddedItems(src, items, reason)
    for index = #(items or {}), 1, -1 do
        removeItem(src, items[index].item, items[index].amount, reason)
    end
end

local function rollbackRemovedItems(src, items, reason)
    for index = #(items or {}), 1, -1 do
        addItem(src, items[index].item, items[index].amount, reason)
    end
end

local function isNearCoords(src, coords, radius)
    local ped = GetPlayerPed(src)

    if ped == 0 or not coords then
        return false
    end

    local distance = #(GetEntityCoords(ped) - coords)
    return distance <= ((tonumber(radius) or 0) + Config.GatherDistanceTolerance)
end

local function buildProfessionResult(professionId, progress)
    local definition = Professions.GetProfessionDefinition(professionId)

    return {
        id = professionId,
        label = definition and definition.label or professionId,
        description = definition and definition.description or '',
        level = progress.level,
        xp = progress.xp,
        xpToNext = Professions.XpToNext(progress.level),
        activities = definition and definition.activities or {},
    }
end

local function hasActiveProfession(state, professionId)
    if type(state) ~= 'table' or type(state.active) ~= 'table' then
        return false
    end

    for _, activeId in ipairs(state.active) do
        if activeId == professionId then
            return true
        end
    end

    return false
end

local function getProfessionSlotItem()
    local item = Config.ProfessionSlotItem

    if not item or not item.enabled or not item.item or (tonumber(item.amount) or 0) <= 0 then
        return nil
    end

    return {
        item = item.item,
        label = item.label or item.item,
        amount = math.floor(tonumber(item.amount) or 1),
        count = 0,
    }
end

local function buildDefaultProfessionState()
    return {
        active = {},
        unlockedSlots = math.max(math.floor(tonumber(Config.DefaultActiveProfessionSlots) or 1), 1),
    }
end

local function applyLevelUps(progress)
    local levelsGained = 0

    while Config.MaxProfessionLevel == 0 or progress.level < Config.MaxProfessionLevel do
        local xpToNext = Professions.XpToNext(progress.level)

        if progress.xp < xpToNext then
            break
        end

        progress.xp = progress.xp - xpToNext
        progress.level = progress.level + 1
        levelsGained = levelsGained + 1
    end

    if Config.MaxProfessionLevel > 0 and progress.level >= Config.MaxProfessionLevel then
        progress.level = Config.MaxProfessionLevel
        progress.xp = 0
    end

    return levelsGained
end

function Professions.EnsurePlayerProfessions(player)
    if not player then
        return nil
    end

    local metadata = player.PlayerData.metadata or {}
    local professionsData, changed = normalizeProfessionsData(metadata.professions)

    if changed then
        setProfessionsData(player, professionsData)
    end

    return professionsData
end

function Professions.EnsurePlayerProfessionState(player)
    if not player then
        return nil
    end

    local professionsData = Professions.EnsurePlayerProfessions(player)
    local metadata = player.PlayerData.metadata or {}
    local state, changed = normalizeProfessionState(metadata.professionState, professionsData)

    if changed then
        setProfessionState(player, state)
    end

    return state
end

function Professions.GetPlayerProfessions(src)
    local player = getPlayer(src)

    if not player then
        return nil
    end

    local professionsData = Professions.EnsurePlayerProfessions(player)
    local results = {}

    for professionId, progress in pairs(professionsData) do
        results[#results + 1] = buildProfessionResult(professionId, progress)
    end

    table.sort(results, function(left, right)
        return left.label < right.label
    end)

    return results
end

function Professions.GetMenuData(src)
    local player = getPlayer(src)

    if not player then
        return nil
    end

    local professionsData = Professions.EnsurePlayerProfessions(player)
    local state = Professions.EnsurePlayerProfessionState(player)
    local professions = {}

    for professionId, progress in pairs(professionsData) do
        local result = buildProfessionResult(professionId, progress)
        result.active = hasActiveProfession(state, professionId)
        professions[#professions + 1] = result
    end

    table.sort(professions, function(left, right)
        return left.label < right.label
    end)

    local active = {}

    for _, professionId in ipairs(state.active) do
        active[#active + 1] = buildProfessionResult(professionId, professionsData[professionId])
    end

    local slotItem = getProfessionSlotItem()

    if slotItem then
        slotItem.count = getItemCount(src, slotItem.item)
    end

    return {
        professions = professions,
        active = active,
        unlockedSlots = state.unlockedSlots,
        maxSlots = Config.MaxActiveProfessionSlots,
        slotItem = slotItem,
    }
end

function Professions.GetProfessionProgress(src, professionId)
    local player = getPlayer(src)

    if not player or not Professions.IsValidProfession(professionId) then
        return nil
    end

    local professionsData = Professions.EnsurePlayerProfessions(player)
    return buildProfessionResult(professionId, professionsData[professionId])
end

function Professions.GetProfessionLevel(src, professionId)
    local progress = Professions.GetProfessionProgress(src, professionId)

    return progress and progress.level or nil
end

function Professions.AddProfessionXp(src, professionId, amount, reason)
    amount = math.floor(tonumber(amount) or 0)

    local player = getPlayer(src)

    if not player then
        return false, 'invalid_player'
    end

    if not Professions.IsValidProfession(professionId) then
        return false, 'invalid_profession'
    end

    local state = Professions.EnsurePlayerProfessionState(player)

    if not hasActiveProfession(state, professionId) and reason ~= 'admin' then
        return false, 'profession_inactive'
    end

    if amount < Config.MinGrantAmount or amount > Config.MaxGrantAmount then
        return false, 'invalid_amount'
    end

    if not isAllowedReason(reason) then
        return false, 'invalid_reason'
    end

    if isRateLimited(src, reason, true) then
        return false, 'rate_limited'
    end

    local professionsData = Professions.EnsurePlayerProfessions(player)
    local progress = professionsData[professionId]
    progress.xp = progress.xp + amount

    local levelsGained = applyLevelUps(progress)
    setProfessionsData(player, professionsData)

    local result = buildProfessionResult(professionId, progress)
    result.levelsGained = levelsGained

    if Config.AuditEnabled then
        Professions.InsertAudit(player.PlayerData.citizenid, professionId, amount, reason, result.level, result.xp)
    end

    if Config.NotifyXpGain then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.xp_granted', { amount = amount, profession = result.label }), 'success')
    end

    if Config.NotifyLevelUp and levelsGained > 0 then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.level_up', { profession = result.label, level = result.level }), 'success')
    end

    TriggerClientEvent('qbx-professions:client:professionUpdated', src, result, amount, reason)
    TriggerEvent('qbx-professions:server:professionXpGranted', src, result, amount, reason)

    return true, result
end

function Professions.ActivateProfession(src, professionId)
    local player = getPlayer(src)

    if not player then
        return false, 'invalid_player'
    end

    if not Professions.IsValidProfession(professionId) then
        return false, 'invalid_profession'
    end

    local state = Professions.EnsurePlayerProfessionState(player)

    if hasActiveProfession(state, professionId) then
        return false, 'profession_already_active'
    end

    if #state.active >= state.unlockedSlots then
        return false, 'profession_slot_required'
    end

    state.active[#state.active + 1] = professionId
    setProfessionState(player, state)

    local result = Professions.GetMenuData(src)

    TriggerClientEvent('qbx-professions:client:professionStateUpdated', src, result)
    TriggerEvent('qbx-professions:server:professionActivated', src, professionId, result)

    return true, result
end

function Professions.UnlockProfessionSlot(src)
    local player = getPlayer(src)

    if not player then
        return false, 'invalid_player'
    end

    local state = Professions.EnsurePlayerProfessionState(player)

    if state.unlockedSlots >= Config.MaxActiveProfessionSlots then
        return false, 'max_profession_slots'
    end

    local oldSlots = state.unlockedSlots
    state.unlockedSlots = state.unlockedSlots + 1
    setProfessionState(player, state)

    local result = Professions.GetMenuData(src)

    if Config.AuditEnabled then
        Professions.InsertSlotAudit(player.PlayerData.citizenid, oldSlots, state.unlockedSlots, 'item')
    end

    TriggerClientEvent('qbx-professions:client:professionStateUpdated', src, result)
    TriggerEvent('qbx-professions:server:professionSlotUnlocked', src, result)

    return true, result
end

function Professions.SetProfessionSlots(src, slots, reason)
    slots = math.floor(tonumber(slots) or 0)

    local player = getPlayer(src)

    if not player then
        return false, 'invalid_player'
    end

    if slots < 1 or slots > Config.MaxActiveProfessionSlots then
        return false, 'invalid_slot_amount'
    end

    local state = Professions.EnsurePlayerProfessionState(player)
    local oldSlots = state.unlockedSlots
    state.unlockedSlots = slots

    while #state.active > state.unlockedSlots do
        state.active[#state.active] = nil
    end

    setProfessionState(player, state)

    local result = Professions.GetMenuData(src)

    if Config.AuditEnabled then
        Professions.InsertSlotAudit(player.PlayerData.citizenid, oldSlots, state.unlockedSlots, reason or 'admin')
    end

    TriggerClientEvent('qbx-professions:client:professionStateUpdated', src, result)
    TriggerEvent('qbx-professions:server:professionSlotsSet', src, result, reason or 'admin')

    return true, result
end

function Professions.DeactivateProfession(src, professionId)
    local player = getPlayer(src)

    if not player then
        return false, 'invalid_player'
    end

    if not Professions.IsValidProfession(professionId) then
        return false, 'invalid_profession'
    end

    local state = Professions.EnsurePlayerProfessionState(player)

    if not hasActiveProfession(state, professionId) then
        return false, 'profession_not_active'
    end

    if #state.active <= 1 then
        return false, 'last_profession_active'
    end

    local active = {}

    for _, activeId in ipairs(state.active) do
        if activeId ~= professionId then
            active[#active + 1] = activeId
        end
    end

    state.active = active
    setProfessionState(player, state)

    local result = Professions.GetMenuData(src)

    TriggerClientEvent('qbx-professions:client:professionStateUpdated', src, result)
    TriggerEvent('qbx-professions:server:professionDeactivated', src, professionId, result)

    return true, result
end

function Professions.ResetPlayerProfessions(src)
    local player = getPlayer(src)

    if not player then
        return false, 'invalid_player'
    end

    local professionsData = {}

    for professionId in pairs(Config.Professions) do
        professionsData[professionId] = copyDefaultProgress()
    end

    local state = buildDefaultProfessionState()

    setProfessionsData(player, professionsData)
    setProfessionState(player, state)

    local result = Professions.GetMenuData(src)

    TriggerClientEvent('qbx-professions:client:professionStateUpdated', src, result)
    TriggerEvent('qbx-professions:server:professionsReset', src, result)

    return true, result
end

function Professions.AttemptGather(src, nodeId)
    local node = Config.GatherNodes[nodeId]

    if not node or not Professions.IsValidProfession(node.profession) then
        return false, 'invalid_gather_node'
    end

    local player = getPlayer(src)

    if not player then
        return false, 'invalid_player'
    end

    local state = Professions.EnsurePlayerProfessionState(player)

    if not hasActiveProfession(state, node.profession) then
        return false, 'profession_inactive'
    end

    local progress = Professions.GetProfessionProgress(src, node.profession)

    if not progress then
        return false, 'invalid_player'
    end

    if progress.level < (node.minLevel or 1) then
        return false, 'level_required'
    end

    if not isNearCoords(src, node.coords, node.radius) then
        return false, 'too_far'
    end

    local now = os.time()
    local readyAt = gatherCooldowns[nodeId] or 0

    if readyAt > now then
        return false, 'node_cooldown', readyAt - now
    end

    if node.tool then
        local hasTool, err = hasItem(src, node.tool.item, node.tool.amount)

        if not hasTool then
            return false, err or 'missing_tool'
        end
    end

    if isRateLimited(src, 'gather', false) then
        return false, 'rate_limited'
    end

    local granted = {}

    for _, reward in ipairs(node.rewards or {}) do
        local chance = tonumber(reward.chance) or 100

        if chance >= 100 or math.random(100) <= chance then
            local canCarry = canAddItem(src, reward.item, reward.amount)

            if not canCarry then
                return false, 'inventory_add_failed'
            end

            granted[#granted + 1] = {
                item = reward.item,
                amount = math.max(math.floor(tonumber(reward.amount) or 1), 1),
            }
        end
    end

    local itemsAdded, addErr = addItems(src, granted, 'qbx-professions:gather')

    if not itemsAdded then
        return false, addErr or 'inventory_add_failed'
    end

    local ok, result = Professions.AddProfessionXp(src, node.profession, node.xp or 1, 'gather')

    if not ok then
        rollbackAddedItems(src, granted, 'qbx-professions:gather-xp-rollback')
        return false, result
    end

    gatherCooldowns[nodeId] = now + math.max(math.floor(tonumber(node.cooldown) or 0), 0) + math.random(0, 4)

    result.node = nodeId
    result.rewards = granted

    return true, result
end

function Professions.AttemptCraft(src, recipeId)
    local recipe = Config.Recipes[recipeId]

    if not recipe or not Professions.IsValidProfession(recipe.profession) then
        return false, 'invalid_recipe'
    end

    local player = getPlayer(src)

    if not player then
        return false, 'invalid_player'
    end

    local state = Professions.EnsurePlayerProfessionState(player)

    if not hasActiveProfession(state, recipe.profession) then
        return false, 'profession_inactive'
    end

    local station = Config.CraftingStations[recipe.station]

    if not station then
        return false, 'invalid_station'
    end

    if not isNearCoords(src, station.coords, station.radius) then
        return false, 'too_far'
    end

    local progress = Professions.GetProfessionProgress(src, recipe.profession)

    if not progress then
        return false, 'invalid_player'
    end

    if progress.level < (recipe.minLevel or 1) then
        return false, 'level_required'
    end

    for _, ingredient in ipairs(recipe.ingredients or {}) do
        local hasIngredient, err = hasItem(src, ingredient.item, ingredient.amount)

        if not hasIngredient then
            return false, err or 'missing_ingredients'
        end
    end

    if isRateLimited(src, 'craft', false) then
        return false, 'rate_limited'
    end

    for _, output in ipairs(recipe.outputs or {}) do
        local canCarry = canAddItem(src, output.item, output.amount)

        if not canCarry then
            return false, 'inventory_add_failed'
        end
    end

    local ingredients = {}

    for _, ingredient in ipairs(recipe.ingredients or {}) do
        ingredients[#ingredients + 1] = {
            item = ingredient.item,
            amount = math.max(math.floor(tonumber(ingredient.amount) or 1), 1),
        }
    end

    local outputs = {}

    for _, output in ipairs(recipe.outputs or {}) do
        outputs[#outputs + 1] = {
            item = output.item,
            amount = math.max(math.floor(tonumber(output.amount) or 1), 1),
        }
    end

    local removedOk, removedOrErr = removeItems(src, ingredients, 'qbx-professions:craft')

    if not removedOk then
        return false, removedOrErr or 'missing_ingredients'
    end

    local addedOk, addedOrErr = addItems(src, outputs, 'qbx-professions:craft')

    if not addedOk then
        rollbackRemovedItems(src, ingredients, 'qbx-professions:craft-add-rollback')
        return false, addedOrErr or 'inventory_add_failed'
    end

    local ok, result = Professions.AddProfessionXp(src, recipe.profession, recipe.xp or 1, 'craft')

    if not ok then
        rollbackAddedItems(src, outputs, 'qbx-professions:craft-xp-rollback')
        rollbackRemovedItems(src, ingredients, 'qbx-professions:craft-xp-rollback')
        return false, result
    end

    result.recipe = recipeId
    result.outputs = outputs

    return true, result
end

AddEventHandler('QBCore:Server:PlayerLoaded', function(player)
    Professions.EnsurePlayerProfessions(player)
    Professions.EnsurePlayerProfessionState(player)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    ensureProfessionSlotItemDefinition()

    local item = getProfessionSlotItem()

    if item and QBCore.Functions.CreateUseableItem then
        QBCore.Functions.CreateUseableItem(item.item, function(source)
            local hasLicense, err = hasItem(source, item.item, item.amount)

            if not hasLicense then
                TriggerClientEvent('QBCore:Notify', source, Lang:t('error.' .. (err or 'profession_slot_item_required')), 'error')
                return
            end

            local player = getPlayer(source)
            local state = player and Professions.EnsurePlayerProfessionState(player) or nil

            if not state then
                TriggerClientEvent('QBCore:Notify', source, Lang:t('error.invalid_player'), 'error')
                return
            end

            if state.unlockedSlots >= Config.MaxActiveProfessionSlots then
                TriggerClientEvent('QBCore:Notify', source, Lang:t('error.max_profession_slots'), 'error')
                return
            end

            local removed, removeErr = removeItem(source, item.item, item.amount, 'qbx-professions:unlock-slot')

            if not removed then
                TriggerClientEvent('QBCore:Notify', source, Lang:t('error.' .. (removeErr or 'profession_slot_item_required')), 'error')
                return
            end

            local ok, result = Professions.UnlockProfessionSlot(source)

            if not ok then
                addItem(source, item.item, item.amount, 'qbx-professions:unlock-slot-rollback')
                TriggerClientEvent('QBCore:Notify', source, Lang:t('error.' .. result), 'error')
                return
            end

            TriggerClientEvent('QBCore:Notify', source, Lang:t('success.profession_slot_unlocked', {
                slots = result.unlockedSlots,
            }), 'success')
        end)
    end
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    for key in pairs(grantBuckets) do
        if key:find(('^%s:'):format(src)) then
            grantBuckets[key] = nil
        end
    end

end)
