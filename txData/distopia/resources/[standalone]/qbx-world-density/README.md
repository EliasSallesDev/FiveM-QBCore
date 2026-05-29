# world-density

Controls ambient population density for Distopia without modifying `qb-core`.

## Current balance

- City vehicle traffic: reduced to 20%.
- Random NPC vehicle traffic: reduced to 15%.
- Parked NPC vehicles: reduced to 25%.
- Pedestrian NPC density: kept at the native maximum multiplier, 100%.
- Scenario pedestrian NPC density: kept at the native maximum multiplier, 100%.

Tune the values in `config.lua`. The GTA/FiveM native density multipliers are intended to run between `0.0` and `1.0`; values above `1.0` are not reliable for increasing population beyond the game default.
