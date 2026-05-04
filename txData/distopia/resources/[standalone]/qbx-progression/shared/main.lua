Progression = Progression or {}

function Progression.XpToNext(level)
    level = tonumber(level) or 1

    if level < 1 then
        level = 1
    end

    return math.floor((Config.XpBase * (level ^ 1.7)) + 0.5)
end

function Progression.DefaultCharacter()
    return {
        level = 1,
        xp = 0,
        skillPoints = 0,
        statAlloc = {},
    }
end
