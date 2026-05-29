Config = {}

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'

Config.Locations = {
    [1] = {
        main = vector3(2397.42, 3089.44, 49.92),
        request = { coords = vector3(2403.51, 3127.95, 48.15), length = 6.0, width = 4.0, heading = 270.0 },
        deliver = { coords = vector3(2351.5, 3132.96, 48.2), length = 6.0, width = 4.0, heading = 270.0 },
        towSpawn = vector4(2411.34, 3136.7, 48.18, 158.0),
    }
}

Config.Job = {
    towTruckModel = 'towtruck2',
    rentalFee = 250,
    deposit = 750,
    cooldown = 5 * 60,
    expiry = 35 * 60,
    searchBlipSprite = 9,
    searchBlipColor = 47,
    searchBlipAlpha = 120,
    deliveryDistance = 15.0,
    targetRegisterDistance = 650.0,
}

Config.Items = {
    'metalscrap',
    'plastic',
    'copper',
    'iron',
    'aluminum',
    'steel',
    'glass',
}

Config.Rarities = {
    common = {
        label = 'Comum',
        chance = 65,
        payout = { min = 350, max = 550 },
        itemRolls = { min = 2, max = 3 },
        itemAmount = { min = 12, max = 22 },
        rubberChance = 15,
        rubberAmount = { min = 4, max = 8 },
    },
    uncommon = {
        label = 'Incomum',
        chance = 25,
        payout = { min = 700, max = 1050 },
        itemRolls = { min = 3, max = 4 },
        itemAmount = { min = 18, max = 30 },
        rubberChance = 25,
        rubberAmount = { min = 8, max = 14 },
    },
    rare = {
        label = 'Raro',
        chance = 8,
        payout = { min = 1400, max = 2200 },
        itemRolls = { min = 4, max = 5 },
        itemAmount = { min = 28, max = 44 },
        rubberChance = 40,
        rubberAmount = { min = 14, max = 24 },
    },
    exotic = {
        label = 'Exotico',
        chance = 2,
        payout = { min = 3200, max = 5200 },
        itemRolls = { min = 5, max = 7 },
        itemAmount = { min = 40, max = 65 },
        rubberChance = 60,
        rubberAmount = { min = 24, max = 42 },
    },
}

Config.VehiclesByRarity = {
    common = { 'asea', 'blista', 'prairie', 'stanier', 'washington', 'picador', 'bobcatxl', 'panto' },
    uncommon = { 'sultan', 'sentinel', 'buffalo', 'dominator', 'oracle', 'jackal', 'schafter2', 'baller' },
    rare = { 'jester', 'comet2', 'feltzer2', 'bullet', 'turismor', 'ninef', 'ninef2' },
    exotic = { 'zentorno', 't20', 'entityxf', 'adder', 'osiris' },
}

Config.SearchZones = {
    {
        name = 'rancho',
        label = 'Rancho / Davis',
        hint = 'Ultimo relato perto de becos, oficinas e ruas industriais.',
        center = vector3(420.0, -1800.0, 28.0),
        radius = 380.0,
        spawns = {
            vector4(396.1, -1835.8, 27.8, 45.0),
            vector4(486.3, -1682.9, 29.2, 320.0),
            vector4(332.5, -2035.1, 20.9, 140.0),
            vector4(552.9, -1775.8, 29.3, 245.0),
        }
    },
    {
        name = 'sandy',
        label = 'Sandy Shores',
        hint = 'Procure em estacionamentos de terra, beiras de estrada e patios abandonados.',
        center = vector3(1735.0, 3670.0, 34.0),
        radius = 520.0,
        spawns = {
            vector4(1702.6, 3591.7, 35.4, 30.0),
            vector4(1851.1, 3710.3, 33.2, 210.0),
            vector4(1594.4, 3776.2, 34.5, 125.0),
            vector4(1962.0, 3746.5, 32.2, 300.0),
        }
    },
    {
        name = 'vespucci',
        label = 'Vespucci / Canais',
        hint = 'O carro foi visto perto de vielas, garagens abertas e ruas estreitas.',
        center = vector3(-1050.0, -1150.0, 3.0),
        radius = 420.0,
        spawns = {
            vector4(-1033.2, -1074.8, 2.1, 210.0),
            vector4(-1155.6, -1254.3, 6.7, 285.0),
            vector4(-913.2, -1197.4, 4.8, 30.0),
            vector4(-1110.3, -985.4, 2.2, 120.0),
        }
    },
    {
        name = 'paleto',
        label = 'Paleto Bay',
        hint = 'Procure perto de oficinas, docas pequenas e ruas afastadas.',
        center = vector3(-220.0, 6260.0, 31.0),
        radius = 520.0,
        spawns = {
            vector4(-216.9, 6218.2, 31.5, 225.0),
            vector4(-78.8, 6422.9, 31.4, 45.0),
            vector4(-359.2, 6062.5, 31.5, 315.0),
            vector4(-447.4, 6132.4, 31.5, 135.0),
        }
    },
}
