Professions = Professions or {}

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

function Professions.CopyTable(value)
    return copyTable(value)
end

function Professions.XpToNext(level)
    level = tonumber(level) or 1

    if level < 1 then
        level = 1
    end

    return math.floor((Config.ProfessionXpBase * (level ^ 1.5)) + 0.5)
end

function Professions.IsValidProfession(professionId)
    return type(professionId) == 'string' and Config.Professions[professionId] ~= nil
end

function Professions.GetProfessionDefinition(professionId)
    if not Professions.IsValidProfession(professionId) then
        return nil
    end

    local definition = copyTable(Config.Professions[professionId])
    definition.id = professionId

    return definition
end

function Professions.DefaultProgress()
    return {
        xp = 0,
        level = 1,
    }
end
