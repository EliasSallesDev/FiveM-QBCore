# Sistema: Zonas e NPCs hostis

## 1. Objetivo e escopo

- **Objetivo:** Mapa segmentado em **tiers** (verde / amarelo / vermelho) com regras de spawn de NPC hostil, armas permitidas ao spawn e densidade. **Safe zones** sem hostis de combate (apenas NPCs de quest story).
- **Princípio de performance:** spawn **local ao jogador** (cada client mantém NPCs ao seu redor) com **seed determinística** partilhada opcionalmente via servidor só para anti-drift — ver secção 4.

## 2. Modelo de zona

| Tier | Cor | NPC hostis | Armas típicas NPC |
|------|-----|------------|-------------------|
| `green` | Safe | Não (exceto NPCs de quest neutros) | — |
| `yellow` | Médio | Sim, baixa densidade | Pistolas, shotguns leves |
| `red` | Alto | Sim, alta densidade | SMG, rifles, heavies |

Definir polígonos em `config.lua` (coords lista) ou DB.

## 3. Statebags

- `Player(src).state.zoneTier` — `green|yellow|red|none`
- Atualizado no servidor quando o jogador cruza fronteira (ox_lib zone callbacks).

## 4. Spawn manager (client-local)

**Fluxo sugerido:**

1. Servidor envia só **config** e **seed de sessão** no login.
2. Cliente divide mundo em **grid cells** (ex.: 50 m).
3. Para cada cell dentro do raio `spawnRadius`, calcula se deve existir patrulha com RNG `hash(seed, cellX, cellY, tier)`.
4. Cria peds **locais** ou **networked** conforme necessidade de sync — documentar trade-off: peds locais reduzem carga global mas complicam loot universal (resolver com servidor ao morto).

**Despawn:** ao sair do raio ou ao mudar de tier — apagar entidades e libertar modelo.

## 5. Catálogo NPC

```lua
Config.HostileArchetypes = {
  yellow_bandit = { models = { `g_m_y_lost_01` }, weapons = { `WEAPON_PISTOL` }, lootPool = 'npc_bandit_yellow' },
  red_militia = { models = { ... }, weapons = { `WEAPON_CARBINERIFLE` }, lootPool = 'npc_red_militia' },
}
```

## 6. Integrações

- Loot ([06](06-loot-e-craft.md))
- Combate ([07](07-combate-pve-pvp.md))
- Battle pass — xp por kill em tier alto ([11](11-battle-pass.md))

## 7. Riscos

- NPC duplicado entre dois jogadores próximos — coordenação por bucket ou networked spawn único (decisão de design).

## 8. Plano de teste

1. Cruzar fronteira — statebag e HUD mudam.
2. Tier vermelho spawna mais NPCs que amarelo à mesma área amostrada.
3. Verde não spawna hostis genéricos.
