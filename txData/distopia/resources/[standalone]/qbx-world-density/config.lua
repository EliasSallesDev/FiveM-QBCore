Config = {}

Config.Debug = false

-- Los Santos urban bounds. Outside this area the game keeps default density.
Config.CityBounds = {
    minX = -2300.0,
    maxX = 1800.0,
    minY = -1900.0,
    maxY = 1400.0,
}

Config.CityDensity = {
    vehicle = 0.20,
    randomVehicle = 0.15,
    parkedVehicle = 0.25,
    ped = 1.00,
    scenarioPed = 1.00,
}

Config.OutsideDensity = {
    vehicle = 1.00,
    randomVehicle = 1.00,
    parkedVehicle = 1.00,
    ped = 1.00,
    scenarioPed = 1.00,
}

Config.DisableAmbientEmergencyServices = true
Config.DisableGarbageTrucks = true
Config.DisableRandomBoats = false
