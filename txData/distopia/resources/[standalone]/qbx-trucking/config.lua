Config = {}

Config.Debug = false
Config.RequiredJob = 'trucker'
Config.RepName = 'trucker'
Config.LegacyRepName = 'delivery'
Config.PayAccount = 'bank'
Config.StartCooldownSeconds = 90
Config.ActionDistance = 12.0
Config.VehicleDistance = 18.0
Config.MinimumFinishBodyHealth = 250.0
Config.MaxDamagePenalty = 0.45
Config.MaxLatePenalty = 0.30
Config.PerfectDeliveryBonus = 0.12
Config.CryptostickChance = 8
Config.ReputationTiers = {
    { name = 'rookie', labelKey = 'tiers.rookie', min = 0, multiplier = 1.00 },
    { name = 'driver', labelKey = 'tiers.driver', min = 25, multiplier = 1.06 },
    { name = 'hauler', labelKey = 'tiers.hauler', min = 75, multiplier = 1.12 },
    { name = 'operator', labelKey = 'tiers.operator', min = 150, multiplier = 1.20 },
    { name = 'master', labelKey = 'tiers.master', min = 300, multiplier = 1.30 },
}

Config.VehicleClasses = {
    city = {
        multiplier = 1.00,
        models = {
            mule = true,
            mule2 = true,
            mule3 = true,
            mule4 = true,
            mule5 = true,
            boxville = true,
            boxville2 = true,
            boxville3 = true,
            boxville4 = true,
            benson = true,
            benson2 = true,
        },
    },
    heavy = {
        multiplier = 1.30,
        models = {
            pounder = true,
            pounder2 = true,
            packer = true,
            biff = true,
            phantom = true,
            phantom3 = true,
            phantom4 = true,
            hauler = true,
            hauler2 = true,
            stockade = true,
        },
    },
    industrial = {
        multiplier = 1.18,
        models = {
            flatbed = true,
            dump = true,
            tiptruck = true,
            tiptruck2 = true,
            mixer = true,
            mixer2 = true,
            rubble = true,
            guardian = true,
        },
    },
    utility = {
        multiplier = 1.08,
        models = {
            towtruck = true,
            towtruck2 = true,
            scrap = true,
            utillitruck = true,
            utillitruck2 = true,
            utillitruck3 = true,
        },
    },
}

Config.Depots = {
    {
        labelKey = 'depots.elysian',
        coords = vector4(1240.59, -3230.92, 5.53, 88.95),
        blip = { sprite = 477, color = 5, scale = 0.7 },
    },
}

Config.Contracts = {
    city_market = {
        labelKey = 'contracts.city_market',
        descKey = 'contracts.city_market_desc',
        classes = { city = true, heavy = true },
        minRep = 0,
        basePay = 2400,
        rep = 3,
        timeLimit = 12,
        cargoUnits = 4,
        pickup = vector4(1240.59, -3230.92, 5.53, 88.95),
        dropoff = vector4(24.46, -1346.58, 29.50, 270.0),
    },
    convenience_route = {
        labelKey = 'contracts.convenience_route',
        descKey = 'contracts.convenience_route_desc',
        classes = { city = true, heavy = true },
        minRep = 15,
        basePay = 3800,
        rep = 5,
        timeLimit = 18,
        cargoUnits = 7,
        pickup = vector4(1240.59, -3230.92, 5.53, 88.95),
        dropoff = vector4(-706.12, -914.56, 19.22, 90.0),
    },
    industrial_parts = {
        labelKey = 'contracts.industrial_parts',
        descKey = 'contracts.industrial_parts_desc',
        classes = { city = true, heavy = true, industrial = true },
        minRep = 35,
        basePay = 5200,
        rep = 7,
        timeLimit = 20,
        cargoUnits = 8,
        pickup = vector4(1240.59, -3230.92, 5.53, 88.95),
        dropoff = vector4(731.26, -1063.01, 22.17, 180.0),
    },
    roadside_recovery = {
        labelKey = 'contracts.roadside_recovery',
        descKey = 'contracts.roadside_recovery_desc',
        classes = { utility = true, industrial = true },
        minRep = 45,
        basePay = 5600,
        rep = 7,
        timeLimit = 18,
        cargoUnits = 3,
        pickup = vector4(-191.37, -1162.57, 23.67, 180.0),
        dropoff = vector4(-427.59, -1728.06, 19.78, 70.0),
    },
    construction_materials = {
        labelKey = 'contracts.construction_materials',
        descKey = 'contracts.construction_materials_desc',
        classes = { industrial = true, heavy = true },
        minRep = 75,
        basePay = 7600,
        rep = 10,
        timeLimit = 24,
        cargoUnits = 10,
        pickup = vector4(1204.91, -3116.91, 5.54, 0.0),
        dropoff = vector4(-474.72, -944.75, 23.96, 88.0),
    },
    paleto_longhaul = {
        labelKey = 'contracts.paleto_longhaul',
        descKey = 'contracts.paleto_longhaul_desc',
        classes = { heavy = true },
        minRep = 150,
        basePay = 12500,
        rep = 16,
        timeLimit = 34,
        cargoUnits = 14,
        pickup = vector4(1240.59, -3230.92, 5.53, 88.95),
        dropoff = vector4(1728.87, 6416.45, 35.04, 245.0),
    },
    secured_stockade = {
        labelKey = 'contracts.secured_stockade',
        descKey = 'contracts.secured_stockade_desc',
        classes = { heavy = true },
        models = { stockade = true },
        minRep = 220,
        basePay = 17000,
        rep = 20,
        timeLimit = 28,
        cargoUnits = 6,
        pickup = vector4(253.81, 228.38, 101.68, 160.0),
        dropoff = vector4(-1212.93, -330.54, 37.79, 207.0),
    },
}
