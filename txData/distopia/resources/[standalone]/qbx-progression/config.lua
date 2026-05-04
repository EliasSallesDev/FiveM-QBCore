Config = Config or {}

Config.XpBase = 120
Config.SkillPointsPerLevel = 1
Config.MaxLevel = 80

Config.AuditEnabled = false
Config.NotifyLevelUp = true
Config.NotifyXpGain = false

Config.MinGrantAmount = 1
Config.MaxGrantAmount = 5000

Config.AllowedReasons = {
    admin = true,
    combat = true,
    quest = true,
    gather = true,
    craft = true,
    survival = true,
    battlepass = true,
}

Config.RateLimits = {
    default = { window = 60, max = 20 },
    combat = { window = 30, max = 10 },
    gather = { window = 30, max = 12 },
    craft = { window = 30, max = 12 },
}
