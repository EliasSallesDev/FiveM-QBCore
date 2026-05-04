# AGENTS — FiveM MMORPG-Survival (qb-core extension)

This file is the **canonical** guide for AI agents (Cursor, Codex, etc.) working on this project. Human-facing documentation in Portuguese (PT-BR) lives under [`docs/`](docs/).

## Project type

- **Runtime**: [FiveM / Cfx.re](https://cfx.re/) (GTA V)
- **Framework base**: [QBCore](https://docs.qbcore.org) — this repo is `qb-core` **v1.3.x** (see [`fxmanifest.lua`](fxmanifest.lua))
- **Language**: Lua **5.4** (`lua54 'yes'`)
- **Server goal**: MMORPG-style survival: classes, professions, XP, skill tree, battle pass, PvE/PvP, quests, loot, crafting, zone-based hostile NPCs, survival (hunger, thirst, disease, cold, bleeding), etc.
- **Extension model**: New gameplay features are **separate resources** (e.g. `qbx-*`) that **do not** modify `qb-core` source. Integrate via `exports`, `metadata`, events, and optional SQL tables.
- **City / brand name**: **Distopia** — narrative and UI should align with [`docs/branding.md`](docs/branding.md).

## Source of truth

| Layer | Path |
|-------|------|
| Branding (city Distopia, logos, NUI rules) | [`docs/branding.md`](docs/branding.md) |
| Human docs (PT-BR) | [`docs/README.md`](docs/README.md) |
| System specs (PT-BR) | [`docs/systems/`](docs/systems/) |
| Architecture & stack | [`docs/01-arquitetura.md`](docs/01-arquitetura.md), [`docs/02-stack-e-ferramentas.md`](docs/02-stack-e-ferramentas.md) |
| Implementation flow | [`docs/04-fluxo-de-implementacao.md`](docs/04-fluxo-de-implementacao.md) |
| Security | [`docs/06-seguranca-e-anti-cheat.md`](docs/06-seguranca-e-anti-cheat.md) |
| Performance | [`docs/05-performance-e-otimizacao.md`](docs/05-performance-e-otimizacao.md) |

## Language conventions

- **User-facing messages** in specs/docs: PT-BR where `docs/` applies.
- **Code identifiers** (variables, events, resource names): English.
- **Git commits**: imperative English (`feat:`, `fix:`, `docs:`).

## Commands & tooling the agent may use

- Local FXServer / txAdmin to **restart resources** and smoke-test.
- **`oxmysql`** migrations: SQL files under each resource’s `sql/` folder (idempotent `CREATE TABLE IF NOT EXISTS`).
- **Lint/format**: `lua-language-server`, **Stylua**, **Selene** (see [`docs/02-stack-e-ferramentas.md`](docs/02-stack-e-ferramentas.md)).
- **Profiling**: `resmon`, built-in **profiler** (`profiler record` / `profiler view`).

Do **not** assume automated CI exists unless configured in this repo.

---

## Hard rules (DO / DON'T)

### Authority & trust model

- **DO** put **game logic authority on the server**. XP, money, items, skill unlocks, loot rolls, quest completion, zone validity → server-side only.
- **DON'T** trust the client for mutations. `RegisterNetEvent` handlers must validate `source`, distance, cooldowns, inventory, and job/class gates.

### Core repo boundaries

- **DO** implement features as **standalone resources** prefixed `qbx-<feature>` (kebab-case).
- **DON'T** edit files under this repo’s **`qb-core`** package (`client/`, `server/`, `shared/` of `qb-core`) for gameplay features — fork/upstream PR is separate. Extend via **`exports['qb-core']:GetCoreObject()`** and hooks (`QBCore:Server:PlayerLoaded`, etc.).

### Database

- **DO** use **`oxmysql`** only (`MySQL.prepare.await`, `MySQL.query.await`, `MySQL.insert`, `MySQL.transaction`). Matches [`fxmanifest.lua`](fxmanifest.lua) dependency.
- **DON'T** use deprecated **`mysql-async`**.

### Player data

- **DO** extend **`PlayerData.metadata.<feature>`** for small, frequently read blobs (level flags, simple counters). Use **`Player.Functions.SetMetaData`** so saves persist via [`server/player.lua`](server/player.lua).
- **DO** create **dedicated tables** for large or relational data (quests, skill nodes per row, battle pass rows). FK by **`citizenid`**.
- **DON'T** alter the **`players`** table schema** in production without a reviewed migration path.

### World / zones / prompts

- **DO** use **`ox_lib`** zones / **`PolyZone`** for spatial triggers — not tight loops on coordinates every frame without sleep.
- **DO** use **`ox_target`** or **`qb-target`** and **`qb-inventory`** or **`ox_inventory`** — don’t reinvent prompts or stash logic.

### Deprecated QBCore patterns

Never wire new code to these (they are exploitable / deprecated — see [`server/events.lua`](server/events.lua)):

- `QBCore:Server:UseItem`, `QBCore:Server:AddItem`, `QBCore:Server:RemoveItem`
- `QBCore:Client:UseItem`

Use **inventory resource APIs** and **server-side** item handlers instead.

### NUI / secrets

- **DO** ship UI under resource **`html/`** with every asset listed in **`files { }`** in `fxmanifest.lua`.
- **DO** include the **Distopia** brand on every NUI surface: **favicon** (96×96 class assets) + **visible logo** in the header (see [`docs/branding.md`](docs/branding.md)). Source pack: [`shared/Pack Logo Distopia/`](shared/Pack%20Logo%20Distopia/) — copy normalized filenames into each resource’s `html/assets/brand/`.
- **DON'T** embed API keys or secrets in client or NUI bundles.

---

## Definition of Done (every feature)

Before marking work complete:

1. **Server validation** for all state changes that affect progression or economy.
2. **SQL migration** committed (`sql/NNNN_description.sql`) if persistence is added.
3. **Locales**: keys in `locale/en.lua` and `locale/pt-br.lua` (or project convention); no raw player-facing strings in Lua.
4. **Exports**: public `exports()` documented in resource README or spec.
5. **Debug helpers**: admin/dev commands gated by ACE (e.g. `qbadmin.allow` or project-specific permission).
6. **Performance**: no busy-loops without `Wait`; respect budgets in [`docs/05-performance-e-otimizacao.md`](docs/05-performance-e-otimizacao.md).
7. **Docs**: update [`docs/systems/00-overview.md`](docs/systems/00-overview.md) matrix if dependencies change; cross-link new external deps in [`docs/09-recursos-externos.md`](docs/09-recursos-externos.md).

---

## Implementation flow (summary)

Detailed steps: **[`docs/04-fluxo-de-implementacao.md`](docs/04-fluxo-de-implementacao.md)**.

1. **Spec** — Copy [`docs/templates/feature-spec-template.md`](docs/templates/feature-spec-template.md) → `docs/systems/` if needed.
2. **Scaffold** — New resource from [`docs/templates/resource-skeleton/`](docs/templates/resource-skeleton/).
3. **Schema** — Idempotent SQL under `sql/`.
4. **Server-first** — Authority, callbacks, DB, `PlayerLoaded` / disconnect hooks.
5. **Client** — Input, threads, NUI.
6. **Config & locale** — All tuning in `config.lua`.
7. **DoD** — PR checklist ([`.github/pull_request_template.md`](.github/pull_request_template.md)).

---

## Cursor-specific note

Project rules live in [`.cursor/rules/`](.cursor/rules/). Rule files apply globs for Lua vs NUI vs core docs.
