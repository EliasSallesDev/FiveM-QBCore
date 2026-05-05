Classes = Classes or {}

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

function Classes.CopyTable(value)
    return copyTable(value)
end

function Classes.XpToNext(level)
    level = tonumber(level) or 1

    if level < 1 then
        level = 1
    end

    return math.floor((Config.ClassXpBase * (level ^ 1.55)) + 0.5)
end

function Classes.IsValidClass(classId)
    return type(classId) == 'string'
        and Config.Classes[classId] ~= nil
        and Config.ClassMods[classId] ~= nil
end

function Classes.GetClassDefinition(classId)
    if not Classes.IsValidClass(classId) then
        return nil
    end

    local definition = copyTable(Config.Classes[classId])
    definition.id = classId

    return definition
end

function Classes.GetAbilityDefinition(abilityId)
    if type(abilityId) ~= 'string' or abilityId == '' then
        return nil
    end

    local ability = Config.Abilities[abilityId]

    if not ability or not Classes.IsValidClass(ability.class) then
        return nil
    end

    local definition = copyTable(ability)
    definition.id = abilityId

    return definition
end

function Classes.GetModifiers(classId)
    local modifiers = copyTable(Config.DefaultModifiers)
    local classModifiers = Config.ClassMods[classId]

    if type(classModifiers) ~= 'table' then
        return modifiers
    end

    for key, value in pairs(classModifiers) do
        modifiers[key] = tonumber(value) or modifiers[key] or 1.0
    end

    return modifiers
end

function Classes.DefaultActiveClassData()
    return {
        id = nil,
        lastChangedAt = 0,
        selectedAt = 0,
        hasChosenClass = false,
    }
end

function Classes.DefaultClassProgress()
    return {
        rank = 0,
        xp = 0,
        level = 1,
        abilityCooldowns = {},
        abilityActives = {},
    }
end
