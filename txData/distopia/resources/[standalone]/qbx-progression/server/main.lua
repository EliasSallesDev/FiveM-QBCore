local QBCore = exports['qb-core']:GetCoreObject()

local grantBuckets = {}

local function copyDefaultCharacter()
    local defaults = Progression.DefaultCharacter()

    return {
        level = defaults.level,
        xp = defaults.xp,
        skillPoints = defaults.skillPoints,
        statAlloc = defaults.statAlloc,
    }
end

local function normalizeCharacterProgress(character)
    local normalized = copyDefaultCharacter()
    local changed = type(character) ~= 'table'

    if type(character) == 'table' then
        local level = math.max(tonumber(character.level) or normalized.level, 1)
        local xp = math.max(tonumber(character.xp) or normalized.xp, 0)
        local skillPoints = math.max(tonumber(character.skillPoints) or normalized.skillPoints, 0)

        normalized.level = level
        normalized.xp = xp
        normalized.skillPoints = skillPoints
        normalized.statAlloc = type(character.statAlloc) == 'table' and character.statAlloc or {}

        changed = changed
            or character.level ~= normalized.level
            or character.xp ~= normalized.xp
            or character.skillPoints ~= normalized.skillPoints
            or type(character.statAlloc) ~= 'table'
    end

    if Config.MaxLevel > 0 and normalized.level > Config.MaxLevel then
        normalized.level = Config.MaxLevel
        normalized.xp = 0
        changed = true
    end

    return normalized, changed
end

local function setCharacterProgress(player, progress)
    local normalized = normalizeCharacterProgress(progress)
    player.Functions.SetMetaData('character', normalized)
end

local function getPlayer(src)
    if not src then
        return nil
    end

    return QBCore.Functions.GetPlayer(src)
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

local function applyLevelUps(progress)
    local levelsGained = 0

    while Config.MaxLevel == 0 or progress.level < Config.MaxLevel do
        local xpToNext = Progression.XpToNext(progress.level)

        if progress.xp < xpToNext then
            break
        end

        progress.xp = progress.xp - xpToNext
        progress.level = progress.level + 1
        progress.skillPoints = progress.skillPoints + Config.SkillPointsPerLevel
        levelsGained = levelsGained + 1
    end

    if Config.MaxLevel > 0 and progress.level >= Config.MaxLevel then
        progress.level = Config.MaxLevel
        progress.xp = 0
    end

    return levelsGained
end

function Progression.EnsurePlayerProgress(player)
    if not player then
        return nil
    end

    local metadata = player.PlayerData.metadata or {}
    local progress, changed = normalizeCharacterProgress(metadata.character)

    if changed then
        setCharacterProgress(player, progress)
    end

    return progress
end

function Progression.GetCharacterProgress(src)
    local player = getPlayer(src)

    if not player then
        return nil
    end

    local progress = Progression.EnsurePlayerProgress(player)

    return {
        level = progress.level,
        xp = progress.xp,
        xpToNext = Progression.XpToNext(progress.level),
        skillPoints = progress.skillPoints,
        statAlloc = progress.statAlloc,
    }
end

function Progression.GrantCharacterXp(src, amount, reason)
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

    local progress = Progression.EnsurePlayerProgress(player)
    progress.xp = progress.xp + amount

    local levelsGained = applyLevelUps(progress)
    setCharacterProgress(player, progress)

    if Config.AuditEnabled then
        Progression.InsertAudit(player.PlayerData.citizenid, amount, reason)
    end

    local result = {
        level = progress.level,
        xp = progress.xp,
        xpToNext = Progression.XpToNext(progress.level),
        skillPoints = progress.skillPoints,
        levelsGained = levelsGained,
    }

    if Config.NotifyXpGain then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.xp_granted', { amount = amount }), 'success')
    end

    if Config.NotifyLevelUp and levelsGained > 0 then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.level_up', { level = progress.level }), 'success')
    end

    TriggerClientEvent('qbx-progression:client:progressUpdated', src, result, amount, reason)
    TriggerEvent('qbx-progression:server:progressUpdated', src, result, amount, reason)

    return true, result
end

AddEventHandler('QBCore:Server:PlayerLoaded', function(player)
    Progression.EnsurePlayerProgress(player)
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    for key in pairs(grantBuckets) do
        if key:find(('^%s:'):format(src)) then
            grantBuckets[key] = nil
        end
    end
end)
