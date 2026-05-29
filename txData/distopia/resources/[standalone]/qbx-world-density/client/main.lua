local activeDensity = Config.OutsideDensity
local inCity = false

local function isInsideCity(coords)
    return coords.x >= Config.CityBounds.minX
        and coords.x <= Config.CityBounds.maxX
        and coords.y >= Config.CityBounds.minY
        and coords.y <= Config.CityBounds.maxY
end

CreateThread(function()
    while true do
        local coords = GetEntityCoords(PlayerPedId())
        inCity = isInsideCity(coords)
        activeDensity = inCity and Config.CityDensity or Config.OutsideDensity

        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        SetVehicleDensityMultiplierThisFrame(activeDensity.vehicle)
        SetRandomVehicleDensityMultiplierThisFrame(activeDensity.randomVehicle)
        SetParkedVehicleDensityMultiplierThisFrame(activeDensity.parkedVehicle)
        SetPedDensityMultiplierThisFrame(activeDensity.ped)
        SetScenarioPedDensityMultiplierThisFrame(activeDensity.scenarioPed, activeDensity.scenarioPed)

        if Config.DisableAmbientEmergencyServices then
            SetCreateRandomCops(false)
            SetCreateRandomCopsNotOnScenarios(false)
            SetCreateRandomCopsOnScenarios(false)
        end

        if Config.DisableGarbageTrucks then
            SetGarbageTrucks(false)
        end

        SetRandomBoats(Config.DisableRandomBoats == false)

        Wait(0)
    end
end)

if Config.Debug then
    RegisterCommand('densitystate', function()
        print(('[world-density] inCity=%s vehicle=%.2f randomVehicle=%.2f parkedVehicle=%.2f ped=%.2f scenarioPed=%.2f'):format(
            inCity,
            activeDensity.vehicle,
            activeDensity.randomVehicle,
            activeDensity.parkedVehicle,
            activeDensity.ped,
            activeDensity.scenarioPed
        ))
    end, false)
end
