# trucking

Freight contracts for player-owned trucks bought from Truck Motor Shop.

## Flow

1. Player takes the `trucker` job.
2. Player brings a personally owned eligible truck to the Elysian Island freight yard.
3. Player opens the freight menu and selects an unlocked contract.
4. Server validates job, distance, driver seat, model, plate, ownership in `player_vehicles`, reputation and cooldown.
5. Player drives to pickup and loads cargo.
6. Player drives to dropoff and delivers cargo.
7. Server validates assigned truck, distance, cargo status and damage before paying.

## Balance

- Contract payout scales by truck class and reputation tier.
- Damage can remove up to `Config.MaxDamagePenalty` from the payout.
- Late delivery can remove up to `Config.MaxLatePenalty` from the payout.
- Clean and on-time deliveries receive `Config.PerfectDeliveryBonus`.
- Completion grants `trucker` and legacy `delivery` reputation.
- Completion can award a `cryptostick` using `Config.CryptostickChance`.

## Exports

- `exports['trucking']:GetActiveContract(source)` returns the active server contract for a player source.
- `exports['trucking']:GetTierForRep(rep)` returns the reputation tier config for a reputation number.

## Notes

No new SQL table is required. Ownership is checked against `player_vehicles`, and progression is stored through QBCore metadata reputation.
