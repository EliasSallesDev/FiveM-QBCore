Config = Config or {}

Config.ProfessionXpBase = 80
Config.MaxProfessionLevel = 50
Config.NotifyXpGain = false
Config.NotifyLevelUp = true
Config.AuditEnabled = false
Config.DefaultActiveProfessionSlots = 1
Config.MaxActiveProfessionSlots = 8

Config.MinGrantAmount = 1
Config.MaxGrantAmount = 5000
Config.GatherDistanceTolerance = 2.0

Config.Inventory = {
    resource = 'qb-inventory',
}

Config.ProfessionSlotItem = {
    enabled = true,
    inventory = 'qb-inventory',
    item = 'profession_license',
    label = 'Licenca de Profissao',
    description = 'Desbloqueia uma profissão ativa adicional.',
    image = 'certificate.png',
    weight = 0,
    amount = 1,
}

Config.AllowedReasons = {
    admin = true,
    gather = true,
    craft = true,
    quest = true,
    tutorial = true,
}

Config.RateLimits = {
    default = { window = 60, max = 30 },
    gather = { window = 60, max = 20 },
    craft = { window = 60, max = 25 },
}

Config.Professions = {
    mining = {
        label = 'Mineracao',
        description = 'Extracao de veios, rochas e pedreiras.',
        activities = { 'Veios minerais', 'Pedreiras', 'Materiais brutos' },
    },
    woodcutting = {
        label = 'Lenharia',
        description = 'Corte e preparo de madeira em arvores marcadas.',
        activities = { 'Arvores marcadas', 'Madeira', 'Recursos de construcao' },
    },
    herbalism = {
        label = 'Herborismo',
        description = 'Coleta de plantas, cogumelos e reagentes naturais.',
        activities = { 'Plantas', 'Cogumelos', 'Reagentes naturais' },
    },
    fishing = {
        label = 'Pesca',
        description = 'Coleta em spots de agua e pesca de subsistencia.',
        activities = { 'Spots de agua', 'Peixes', 'Iscas e comida' },
    },
    cooking = {
        label = 'Cozinha',
        description = 'Preparo de alimentos e comidas com buffs.',
        activities = { 'Comidas', 'Buffs leves', 'Receitas de sobrevivencia' },
    },
    alchemy = {
        label = 'Alquimia',
        description = 'Pocoes, antidotos e reagentes refinados.',
        activities = { 'Pocoes', 'Antidotos', 'Reagentes refinados' },
    },
    blacksmith = {
        label = 'Ferraria',
        description = 'Forja de armas, armaduras e pecas metalicas.',
        activities = { 'Forja', 'Metalurgia', 'Armas e armaduras' },
    },
    gunsmith = {
        label = 'Mecanica de armas',
        description = 'Mods, reparo avancado e ajuste de armamentos.',
        activities = { 'Mods de arma', 'Reparo avancado', 'Bancada tecnica' },
    },
}

Config.GatherNodes = {
    stone_quarry = {
        label = 'Pedreira',
        profession = 'mining',
        coords = vector3(2952.48, 2793.15, 40.73),
        radius = 18.0,
        cooldown = 45,
        minLevel = 1,
        tool = { item = 'pickaxe', amount = 1 },
        xp = 18,
        rewards = {
            { item = 'stone', amount = 2 },
            { item = 'metalscrap', amount = 1, chance = 35 },
        },
    },
    marked_trees = {
        label = 'Arvores marcadas',
        profession = 'woodcutting',
        coords = vector3(-557.14, 5369.02, 70.32),
        radius = 20.0,
        cooldown = 45,
        minLevel = 1,
        tool = { item = 'hatchet', amount = 1 },
        xp = 18,
        rewards = {
            { item = 'wood', amount = 2 },
        },
    },
    wild_herbs = {
        label = 'Ervas selvagens',
        profession = 'herbalism',
        coords = vector3(2225.51, 5577.37, 53.83),
        radius = 16.0,
        cooldown = 40,
        minLevel = 1,
        tool = nil,
        xp = 14,
        rewards = {
            { item = 'herb', amount = 2 },
            { item = 'mushroom', amount = 1, chance = 25 },
        },
    },
    shoreline_fishing = {
        label = 'Pesca costeira',
        profession = 'fishing',
        coords = vector3(-1846.51, -1250.95, 8.62),
        radius = 24.0,
        cooldown = 50,
        minLevel = 1,
        tool = { item = 'fishingrod', amount = 1 },
        xp = 16,
        rewards = {
            { item = 'fish', amount = 1 },
        },
    },
}

Config.CraftingStations = {
    campfire = {
        label = 'Fogueira',
        coords = vector3(1391.19, 3605.78, 38.94),
        radius = 3.0,
    },
    alchemy_table = {
        label = 'Mesa de alquimia',
        coords = vector3(2433.44, 4969.67, 42.35),
        radius = 3.0,
    },
    forge = {
        label = 'Forja',
        coords = vector3(1109.16, -2007.87, 31.06),
        radius = 4.0,
    },
    weapons_bench = {
        label = 'Bancada de armas',
        coords = vector3(844.42, -1033.41, 28.19),
        radius = 3.0,
    },
}

Config.Recipes = {
    cooked_fish = {
        label = 'Peixe cozido',
        profession = 'cooking',
        minLevel = 1,
        station = 'campfire',
        xp = 12,
        ingredients = {
            { item = 'fish', amount = 1 },
        },
        outputs = {
            { item = 'cooked_fish', amount = 1 },
        },
    },
    antidote = {
        label = 'Antidoto simples',
        profession = 'alchemy',
        minLevel = 1,
        station = 'alchemy_table',
        xp = 18,
        ingredients = {
            { item = 'herb', amount = 2 },
            { item = 'mushroom', amount = 1 },
        },
        outputs = {
            { item = 'antidote', amount = 1 },
        },
    },
    iron_plate = {
        label = 'Placa metalica',
        profession = 'blacksmith',
        minLevel = 1,
        station = 'forge',
        xp = 16,
        ingredients = {
            { item = 'metalscrap', amount = 2 },
        },
        outputs = {
            { item = 'iron_plate', amount = 1 },
        },
    },
    weapon_repair_kit = {
        label = 'Kit de reparo de armas',
        profession = 'gunsmith',
        minLevel = 1,
        station = 'weapons_bench',
        xp = 20,
        ingredients = {
            { item = 'metalscrap', amount = 2 },
            { item = 'iron_plate', amount = 1 },
        },
        outputs = {
            { item = 'weapon_repair_kit', amount = 1 },
        },
    },
}
