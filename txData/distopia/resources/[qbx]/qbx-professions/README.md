# qbx-professions

Distopia profession progression for QBCore. The resource owns economic/crafting XP independently from combat classes.

## Persistence

Small, hot progress data is stored in `PlayerData.metadata.professions`:

```lua
professions = {
    mining = { xp = 0, level = 1 },
}
```

Active profession choices and unlocked active slots are stored in `PlayerData.metadata.professionState`:

```lua
professionState = {
    active = {},
    unlockedSlots = 1,
}
```

XP grants can be audited in `qbx_profession_audit`, and slot changes can be audited in `qbx_profession_slot_audit`; run the SQL files under `sql/` before enabling `Config.AuditEnabled`.

## Server exports

```lua
exports['qbx-professions']:AddProfessionXp(src, professionId, amount, reason)
exports['qbx-professions']:GetProfessionLevel(src, professionId)
exports['qbx-professions']:GetProfessionProgress(src, professionId)
exports['qbx-professions']:GetPlayerProfessions(src)
exports['qbx-professions']:GetMenuData(src)
exports['qbx-professions']:ActivateProfession(src, professionId)
exports['qbx-professions']:UnlockProfessionSlot(src)
exports['qbx-professions']:SetProfessionSlots(src, slots, reason)
exports['qbx-professions']:DeactivateProfession(src, professionId)
exports['qbx-professions']:ResetPlayerProfessions(src)
exports['qbx-professions']:AttemptGather(src, nodeId)
exports['qbx-professions']:AttemptCraft(src, recipeId)
```

Allowed XP reasons are configured in `Config.AllowedReasons`. Economy mutations must go through server exports/callbacks so active profession, distance, cooldown, level, inventory and recipe requirements are validated server-side.

## Selection HUD

- `/professions` or `/chooseprofession` opens the Distopia profession HUD.
- A character starts with `Config.DefaultActiveProfessionSlots` available slot and no active profession; the first profession is chosen by the player.
- Activating a profession fills a free slot; it does not replace existing active professions.
- `Config.ProfessionSlotItem` defines the consumable item that unlocks another active slot.

## Contracts for future resources

- Gather nodes live in `Config.GatherNodes` and validate profession, level, distance, cooldown and tool.
- Craft recipes live in `Config.Recipes` and validate station distance, profession level and ingredients.
- Item IDs in gather rewards, tools, ingredients and outputs are contracts for the inventory item pack; defining those items remains outside this resource.
- `qbx-lootcraft` can gate recipes with `GetProfessionLevel(src, professionId)`.
- `qbx-quests` can call `AddProfessionXp(src, professionId, amount, 'quest')` after server-side objective validation.

## Commands

- `/profession [professionId]` shows current progress.
- `/activateprofession <professionId>` activates a profession when a free slot exists.
- `/deactivateprofession <player> <professionId>` deactivates one profession, admin only.
- `/setprofessionslots <player> <amount>` sets active slot count, admin only.
- `/resetprofessions <player>` resets profession progress and active slots, admin only.
- `/grantprofessionxp <player> <professionId> <amount> [reason]` grants XP, admin only.
- `/professiongather <nodeId>` smoke-tests a gather node, admin only.
- `/professioncraft <recipeId>` smoke-tests a recipe, admin only.

## Inventory safety

Gather and craft operations pre-check carry capacity and use best-effort rollback helpers. If a later step fails, the resource attempts to remove already-added outputs/rewards and restore removed ingredients before returning an error. This is still bounded by the inventory export behavior, so full transaction guarantees should live in the inventory layer if that becomes available.

## Target/zones integration

This resource keeps gather nodes and crafting stations as server contracts in `Config.GatherNodes` and `Config.CraftingStations`. A target or zone resource should call `qbx-professions:server:gather`, `qbx-professions:server:craft`, or the matching exports after the player interacts with a validated prompt; the profession resource will still revalidate distance, level, active profession, cooldown, tools and inventory server-side.
