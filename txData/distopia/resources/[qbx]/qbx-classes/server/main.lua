local QBCore = exports['qb-core']:GetCoreObject()

local grantBuckets = {}

local function ensureClassChangeItemDefinition()
    local item = Config.ClassChangeItem or Config.ClassChangeCost

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
        useable = false,
        shouldClose = true,
        description = item.description or 'Permite trocar de classe uma vez.',
    }
end

ensureClassChangeItemDefinition()

local function getPlayer(src)
    if not src then
        return nil
    end

    return QBCore.Functions.GetPlayer(src)
end

local function copyDefaultActiveClassData()
    return Classes.DefaultActiveClassData()
end

local function copyDefaultClassProgress()
    return Classes.DefaultClassProgress()
end

local function normalizeActiveClassData(classData)
    local normalized = copyDefaultActiveClassData()
    local changed = type(classData) ~= 'table'

    if type(classData) == 'table' then
        if Classes.IsValidClass(classData.id) then
            normalized.id = classData.id
        elseif classData.id == nil or classData.id == false or classData.id == '' then
            normalized.id = nil
        else
            changed = true
        end

        normalized.lastChangedAt = math.max(math.floor(tonumber(classData.lastChangedAt) or 0), 0)
        normalized.selectedAt = math.max(math.floor(tonumber(classData.selectedAt) or 0), 0)
        normalized.hasChosenClass = classData.hasChosenClass == true
            or normalized.selectedAt > 0
            or normalized.lastChangedAt > 0

        changed = changed
            or classData.id ~= normalized.id
            or classData.lastChangedAt ~= normalized.lastChangedAt
            or classData.selectedAt ~= normalized.selectedAt
            or classData.hasChosenClass ~= normalized.hasChosenClass
            or classData.rank ~= nil
            or classData.xp ~= nil
            or classData.level ~= nil
            or classData.abilityCooldowns ~= nil
            or classData.abilityActives ~= nil
    end

    return normalized, changed
end

local function normalizeClassProgress(progress)
    local normalized = copyDefaultClassProgress()
    local changed = type(progress) ~= 'table'

    if type(progress) == 'table' then
        normalized.rank = math.max(math.floor(tonumber(progress.rank) or normalized.rank), 0)
        normalized.xp = math.max(math.floor(tonumber(progress.xp) or normalized.xp), 0)
        normalized.level = math.max(math.floor(tonumber(progress.level) or normalized.level), 1)
        normalized.abilityCooldowns = type(progress.abilityCooldowns) == 'table' and progress.abilityCooldowns or {}
        normalized.abilityActives = type(progress.abilityActives) == 'table' and progress.abilityActives or {}

        changed = changed
            or progress.rank ~= normalized.rank
            or progress.xp ~= normalized.xp
            or progress.level ~= normalized.level
            or type(progress.abilityCooldowns) ~= 'table'
            or type(progress.abilityActives) ~= 'table'
    end

    if Config.MaxClassLevel > 0 and normalized.level > Config.MaxClassLevel then
        normalized.level = Config.MaxClassLevel
        normalized.xp = 0
        changed = true
    end

    return normalized, changed
end

local function normalizeClassesData(classesData, activeClassId, legacyClassData)
    local normalized = {}
    local changed = type(classesData) ~= 'table'

    for classId in pairs(Config.Classes) do
        local progressSource = type(classesData) == 'table' and classesData[classId] or nil

        if not progressSource and classId == activeClassId and type(legacyClassData) == 'table' then
            progressSource = {
                rank = legacyClassData.rank,
                xp = legacyClassData.xp,
                level = legacyClassData.level,
                abilityCooldowns = legacyClassData.abilityCooldowns,
                abilityActives = legacyClassData.abilityActives,
            }
            changed = true
        end

        local progress, progressChanged = normalizeClassProgress(progressSource)
        normalized[classId] = progress
        changed = changed or progressChanged
    end

    return normalized, changed
end

local function setClassState(player, activeClass, classesData)
    player.Functions.SetMetaData('class', activeClass)
    player.Functions.SetMetaData('classes', classesData)
end

local function getPrimaryAbility(classId)
    for abilityId, ability in pairs(Config.Abilities) do
        if ability.class == classId then
            local definition = Classes.GetAbilityDefinition(abilityId)
            return definition
        end
    end

    return nil
end

local function getSkillTreeModifiers(src)
    if GetResourceState('qbx-skilltree') ~= 'started' then
        return {}
    end

    local ok, modifiers = pcall(function()
        return exports['qbx-skilltree']:GetSkillModifiers(src)
    end)

    if not ok or type(modifiers) ~= 'table' then
        return {}
    end

    return modifiers
end

local function getSkillTreeAbilityRanks(src)
    if GetResourceState('qbx-skilltree') ~= 'started' then
        return {}
    end

    local ok, ranks = pcall(function()
        return exports['qbx-skilltree']:GetAbilityRanks(src)
    end)

    if not ok or type(ranks) ~= 'table' then
        return {}
    end

    return ranks
end

local function buildEffectiveModifiers(classId, src)
    local modifiers = Classes.GetModifiers(classId)

    for key, value in pairs(getSkillTreeModifiers(src)) do
        modifiers[key] = (modifiers[key] or 1.0) + (tonumber(value) or 0)
    end

    return modifiers
end

local function buildEffectiveAbility(src, ability)
    if type(ability) ~= 'table' then
        return nil
    end

    local adjusted = Classes.CopyTable(ability)
    local ranks = getSkillTreeAbilityRanks(src)
    local bonusRank = math.max(math.floor(tonumber(ranks[adjusted.id]) or 0), 0)

    adjusted.skillRank = 1 + bonusRank
    adjusted.duration = math.max(math.floor((tonumber(adjusted.duration) or 0) * (1.0 + (bonusRank * 0.10)) + 0.5), 0)
    adjusted.cooldown = math.max(math.floor((tonumber(adjusted.cooldown) or 0) * (1.0 - math.min(bonusRank * 0.10, 0.50)) + 0.5), 0)

    return adjusted
end

local function buildAbilityStatus(classId, progress, src)
    local ability = getPrimaryAbility(classId)

    if not ability then
        return nil
    end

    ability = buildEffectiveAbility(src, ability)

    local now = os.time()
    local duration = math.max(math.floor(tonumber(ability.duration) or 0), 0)
    local cooldown = math.max(math.floor(tonumber(ability.cooldown) or 0), 0)
    local activeUntil = math.max(math.floor(tonumber(progress.abilityActives[ability.id]) or 0), 0)
    local lastUsedAt = math.max(math.floor(tonumber(progress.abilityCooldowns[ability.id]) or 0), 0)
    local cooldownUntil = lastUsedAt + cooldown
    local activeRemaining = math.max(activeUntil - now, 0)
    local cooldownRemaining = math.max(cooldownUntil - now, 0)
    local state = 'ready'

    if activeRemaining > 0 then
        state = 'active'
    elseif cooldownRemaining > 0 then
        state = 'cooldown'
    end

    return {
        id = ability.id,
        label = ability.label,
        description = ability.description,
        minLevel = ability.minLevel or 1,
        staminaCost = ability.staminaCost or 0,
        duration = duration,
        cooldown = cooldown,
        activeUntil = activeUntil,
        cooldownUntil = cooldownUntil,
        activeRemaining = activeRemaining,
        cooldownRemaining = cooldownRemaining,
        state = state,
        skillRank = ability.skillRank or 1,
    }
end

local function buildClassResult(activeClass, progress, src)
    if not activeClass or not Classes.IsValidClass(activeClass.id) or not progress then
        return nil
    end

    local definition = Classes.GetClassDefinition(activeClass.id)

    return {
        id = activeClass.id,
        label = definition and definition.label or activeClass.id,
        role = definition and definition.role or '',
        rank = progress.rank,
        xp = progress.xp,
        xpToNext = Classes.XpToNext(progress.level),
        level = progress.level,
        lastChangedAt = activeClass.lastChangedAt,
        selectedAt = activeClass.selectedAt,
        hasChosenClass = activeClass.hasChosenClass,
        modifiers = buildEffectiveModifiers(activeClass.id, src),
        abilityStatus = buildAbilityStatus(activeClass.id, progress, src),
    }
end

local function isAllowedReason(reason)
    return type(reason) == 'string'
        and reason ~= ''
        and #reason <= 64
        and Config.AllowedReasons[reason] == true
end

local function isRateLimited(src, reason)
    local rule = Config.RateLimits[reason] or Config.RateLimits.default

    if not rule then
        return false
    end

    local now = os.time()
    local key = ('%s:%s'):format(src, reason)
    local bucket = grantBuckets[key]

    if not bucket or now - bucket.startedAt >= rule.window then
        grantBuckets[key] = {
            startedAt = now,
            count = 1,
        }

        return false
    end

    bucket.count = bucket.count + 1
    return bucket.count > rule.max
end

local function isInCombat(src)
    if not Config.BlockClassChangeWhileInCombat then
        return false
    end

    local state = Player(src).state

    for _, key in ipairs(Config.CombatStateKeys) do
        if state[key] == true then
            return true
        end
    end

    return false
end

local function getClassChangeCost()
    local cost = Config.ClassChangeItem or Config.ClassChangeCost

    if not cost or not cost.enabled or not cost.item or (tonumber(cost.amount) or 0) <= 0 then
        return nil
    end

    return {
        inventory = cost.inventory or 'qb-inventory',
        item = cost.item,
        label = cost.label or cost.item,
        amount = math.floor(tonumber(cost.amount) or 1),
    }
end

local function chargeClassChangeCost(src)
    local cost = getClassChangeCost()

    if not cost then
        return true
    end

    if GetResourceState(cost.inventory) ~= 'started' then
        return false, 'inventory_unavailable'
    end

    if cost.inventory == 'qb-inventory' then
        if not exports['qb-inventory']:HasItem(src, cost.item, cost.amount) then
            return false, 'insufficient_cost'
        end

        if not exports['qb-inventory']:RemoveItem(src, cost.item, cost.amount, false, 'qbx-classes:class-change') then
            return false, 'insufficient_cost'
        end

        return true
    end

    if cost.inventory == 'ox_inventory' then
        local count = tonumber(exports['ox_inventory']:Search(src, 'count', cost.item)) or 0

        if count < cost.amount then
            return false, 'insufficient_cost'
        end

        if not exports['ox_inventory']:RemoveItem(src, cost.item, cost.amount) then
            return false, 'insufficient_cost'
        end

        return true
    end

    return false, 'inventory_unavailable'
end

local function applyClassLevelUps(progress)
    local levelsGained = 0

    while Config.MaxClassLevel == 0 or progress.level < Config.MaxClassLevel do
        local xpToNext = Classes.XpToNext(progress.level)

        if progress.xp < xpToNext then
            break
        end

        progress.xp = progress.xp - xpToNext
        progress.level = progress.level + 1
        levelsGained = levelsGained + 1
    end

    if Config.MaxClassLevel > 0 and progress.level >= Config.MaxClassLevel then
        progress.level = Config.MaxClassLevel
        progress.xp = 0
    end

    return levelsGained
end

local function enforceSingleClassProgress(classesData, activeClassId)
    if not Config.SingleClassOnly then
        return
    end

    for classId in pairs(classesData) do
        if classId ~= activeClassId then
            classesData[classId] = copyDefaultClassProgress()
        end
    end
end

local function runAbilityResourceHook(hookName, src, ability, classData)
    local hook = Config[hookName]

    if type(hook) ~= 'function' then
        return true
    end

    local ok, allowed, err = pcall(hook, src, ability, classData)

    if not ok then
        print(('[qbx-classes] %s failed for ability=%s error=%s'):format(hookName, tostring(ability.id), tostring(allowed)))
        return false, 'ability_resource_failed'
    end

    if allowed == false then
        return false, err or 'ability_resource_unavailable'
    end

    return true
end

function Classes.EnsurePlayerClass(player)
    if not player then
        return nil
    end

    local metadata = player.PlayerData.metadata or {}
    local activeClass, activeChanged = normalizeActiveClassData(metadata.class)
    local classesData, classesChanged = normalizeClassesData(metadata.classes, activeClass.id, metadata.class)

    if activeChanged or classesChanged then
        setClassState(player, activeClass, classesData)
    end

    return activeClass, classesData
end

function Classes.GetPlayerClass(src)
    local player = getPlayer(src)

    if not player then
        return nil
    end

    local activeClass, classesData = Classes.EnsurePlayerClass(player)

    if not activeClass.id then
        return nil
    end

    return buildClassResult(activeClass, classesData[activeClass.id], src)
end

function Classes.GetClassId(src)
    local player = getPlayer(src)

    if not player then
        return nil
    end

    local activeClass = Classes.EnsurePlayerClass(player)
    return activeClass and activeClass.id or nil
end

function Classes.GetClassModifiers(src)
    local classId = Classes.GetClassId(src)

    if not classId then
        return nil
    end

    return buildEffectiveModifiers(classId, src)
end

function Classes.GetClassMenuData(src)
    local player = getPlayer(src)

    if not player then
        return nil
    end

    local activeClass, classesData = Classes.EnsurePlayerClass(player)
    local classes = {}

    for classId in pairs(Config.Classes) do
        classes[#classes + 1] = buildClassResult({
            id = classId,
            lastChangedAt = activeClass.lastChangedAt,
            selectedAt = activeClass.selectedAt,
            hasChosenClass = activeClass.hasChosenClass,
        }, classesData[classId], src)
    end

    table.sort(classes, function(left, right)
        return left.label < right.label
    end)

    return {
        active = activeClass.id and buildClassResult(activeClass, classesData[activeClass.id], src) or nil,
        classes = classes,
        classChangeCost = getClassChangeCost(),
        classChangeCooldown = Config.ClassChangeCooldown,
        freeInitialClassChoice = Config.FreeInitialClassChoice and not activeClass.hasChosenClass,
    }
end

function Classes.SetPlayerClass(src, classId, force)
    local player = getPlayer(src)

    if not player then
        return false, 'invalid_player'
    end

    if not Classes.IsValidClass(classId) then
        return false, 'invalid_class'
    end

    local activeClass, classesData = Classes.EnsurePlayerClass(player)
    local isInitialChoice = Config.FreeInitialClassChoice and not activeClass.hasChosenClass

    if activeClass.id == classId and not isInitialChoice then
        return false, 'same_class'
    end

    local now = os.time()

    if not force and not isInitialChoice then
        local remaining = Config.ClassChangeCooldown - (now - activeClass.lastChangedAt)

        if Config.ClassChangeCooldown > 0 and remaining > 0 then
            return false, 'class_change_cooldown', remaining
        end

        if isInCombat(src) then
            return false, 'class_change_in_combat'
        end

        local paid, err = chargeClassChangeCost(src)

        if not paid then
            return false, err
        end
    end

    activeClass.id = classId
    activeClass.lastChangedAt = now
    activeClass.selectedAt = activeClass.selectedAt > 0 and activeClass.selectedAt or now
    activeClass.hasChosenClass = true

    if Config.ResetTargetProgressOnClassChange or Config.ResetProgressOnClassChange then
        classesData[classId] = copyDefaultClassProgress()
    end

    enforceSingleClassProgress(classesData, classId)

    setClassState(player, activeClass, classesData)

    local result = buildClassResult(activeClass, classesData[classId], src)

    if Config.NotifyClassChange then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.class_changed', { class = result.label }), 'success')
    end

    TriggerClientEvent('qbx-classes:client:classUpdated', src, result)
    TriggerEvent('qbx-classes:server:classUpdated', src, result)

    return true, result
end

function Classes.GrantClassXp(src, amount, reason)
    amount = math.floor(tonumber(amount) or 0)

    local player = getPlayer(src)

    if not player then
        return false, 'invalid_player'
    end

    if amount < Config.MinGrantAmount or amount > Config.MaxGrantAmount then
        return false, 'invalid_amount'
    end

    if not isAllowedReason(reason) then
        return false, 'invalid_reason'
    end

    if isRateLimited(src, reason) then
        return false, 'rate_limited'
    end

    local activeClass, classesData = Classes.EnsurePlayerClass(player)

    if not activeClass.id then
        return false, 'class_not_chosen'
    end

    local progress = classesData[activeClass.id]
    progress.xp = progress.xp + amount

    local levelsGained = applyClassLevelUps(progress)
    setClassState(player, activeClass, classesData)

    local result = buildClassResult(activeClass, progress, src)
    result.levelsGained = levelsGained

    if Config.NotifyClassXpGain then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.xp_granted', { amount = amount }), 'success')
    end

    if Config.NotifyClassLevelUp and levelsGained > 0 then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.class_level_up', {
            class = result.label,
            level = result.level,
        }), 'success')
    end

    TriggerClientEvent('qbx-classes:client:classUpdated', src, result, amount, reason)
    TriggerEvent('qbx-classes:server:classXpGranted', src, result, amount, reason)

    return true, result
end

function Classes.TryUseAbility(src, abilityId)
    local player = getPlayer(src)

    if not player then
        return false, 'invalid_player'
    end

    local ability = Classes.GetAbilityDefinition(abilityId)

    if not ability then
        return false, 'invalid_ability'
    end

    ability = buildEffectiveAbility(src, ability)

    local activeClass, classesData = Classes.EnsurePlayerClass(player)

    if not activeClass.id then
        return false, 'class_not_chosen'
    end

    local progress = classesData[activeClass.id]

    if activeClass.id ~= ability.class then
        return false, 'ability_wrong_class'
    end

    if progress.level < (ability.minLevel or 1) then
        return false, 'ability_level_required'
    end

    local now = os.time()
    local lastUsedAt = tonumber(progress.abilityCooldowns[ability.id]) or 0
    local remaining = (ability.cooldown or 0) - (now - lastUsedAt)

    if remaining > 0 then
        return false, 'ability_cooldown', remaining
    end

    local classData = buildClassResult(activeClass, progress, src)
    local resourceOk, resourceErr = runAbilityResourceHook('AbilityResourceCheck', src, ability, classData)

    if not resourceOk then
        return false, resourceErr
    end

    local consumeOk, consumeErr = runAbilityResourceHook('AbilityResourceConsume', src, ability, classData)

    if not consumeOk then
        return false, consumeErr
    end

    progress.abilityCooldowns[ability.id] = now

    if (ability.duration or 0) > 0 then
        progress.abilityActives[ability.id] = now + math.floor(tonumber(ability.duration) or 0)
    end

    setClassState(player, activeClass, classesData)

    local result = buildClassResult(activeClass, progress, src)

    TriggerClientEvent('qbx-classes:client:abilityUsed', src, ability, result.abilityStatus)
    TriggerClientEvent('qbx-classes:client:classUpdated', src, result)
    TriggerEvent('qbx-classes:server:abilityUsed', src, ability, result.abilityStatus)

    return true, ability
end

AddEventHandler('QBCore:Server:PlayerLoaded', function(player)
    Classes.EnsurePlayerClass(player)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    ensureClassChangeItemDefinition()
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    for key in pairs(grantBuckets) do
        if key:find(('^%s:'):format(src)) then
            grantBuckets[key] = nil
        end
    end
end)
