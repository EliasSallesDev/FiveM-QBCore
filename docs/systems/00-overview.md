# Visão geral dos sistemas — matriz de dependências

Este documento liga as specs de gameplay. **Atualizar** sempre que um resource novo for adicionado ou a ordem de `ensure` mudar.

## Recursos sugeridos (nomes lógicos)

| Resource sugerido | Spec |
|---------------------|------|
| `qbx-progression` | [01-personagem-e-progressao.md](01-personagem-e-progressao.md) |
| `qbx-classes` | [02-classes.md](02-classes.md) |
| `qbx-professions` | [03-profissoes.md](03-profissoes.md) |
| `qbx-skilltree` | [04-skill-tree.md](04-skill-tree.md) |
| `qbx-quests` | [05-quests.md](05-quests.md) |
| `qbx-lootcraft` | [06-loot-e-craft.md](06-loot-e-craft.md) |
| `qbx-combat` | [07-combate-pve-pvp.md](07-combate-pve-pvp.md) |
| `qbx-status` | [08-sangramento-e-status.md](08-sangramento-e-status.md) |
| `qbx-zones` | [09-zonas-e-npc-hostis.md](09-zonas-e-npc-hostis.md) |
| `qbx-survival` | [10-survival-fome-sede-doencas-frio.md](10-survival-fome-sede-doencas-frio.md) |
| `qbx-battlepass` | [11-battle-pass.md](11-battle-pass.md) |
| `trucking` | Caminhoneiro / fretes com caminhoes pessoais |

## Matriz de dependências

Legenda: **→** depende de.

| Sistema | Depende de | Consumido por |
|---------|------------|----------------|
| Personagem / XP | `qb-core` | Classes, profissões, skill tree, battle pass, quests |
| Classes | Progressão, core | Combate, skill tree, algumas quests |
| Profissões | Progressão, inventário | Craft, loot (uso de ferramentas), quests gather |
| Caminhoneiro / fretes | `qb-core`, `qb-menu`, `qb-inventory`, `player_vehicles` | Economia, lojas, progressao de profissao |
| Skill tree | Classes (ou neutra), progressão | Combate, survival (passivas), profissões |
| Quests | Zonas (opcional), NPCs | Battle pass (missões), profissões (tutorial) |
| Loot & Craft | Profissões, inventário | Progressão indireta (gear), economia |
| Combate PvE/PvP | Classes, skill tree, zonas | Status (bleed), loot (drops), battle pass |
| Sangramento & status | Combate, survival | HUD médico, consumíveis |
| Zonas & NPCs | `ox_lib`/PolyZone, target | Combate, loot, battle pass, survival (frio), quests |
| Survival (fome, frio, doença) | Core (`metadata` fome/sede), zonas | Combate (debuffs), quests survive |
| Battle pass | Progressão, quests, combate | — (endpoint de recompensas) |

## Ordem atual/sugerida no `server.cfg`

```
ensure oxmysql
ensure qb-core
ensure [qb]
ensure qbx-progression
ensure qbx-classes
ensure qbx-professions
ensure qbx-skilltree
ensure [standalone]
# --- sistemas qbx ---
ensure qbx-zones
ensure qbx-combat
ensure qbx-status
ensure qbx-survival
ensure qbx-lootcraft
ensure qbx-quests
ensure qbx-battlepass
ensure trucking
```

Ajusta conforme implementação real (podes fundir recursos se reduzires granularidade).

## Eventos transversais (contrato)

- `QBCore:Server:PlayerLoaded` — todos os `qbx-*` devem registar init idempotente.
- Progressão global: evento interno sugerido `qbx-common:server:grantCharacterXp` (definir num resource `qbx-common` ou no primeiro a carregar) para evitar dependências circulares.

## Notas

- **Zonas** são base para PvP, tier de NPC, clima percebido e survival — manter a spec de zonas estável cedo no desenvolvimento.
- **Battle pass** deve só **ouvir** conclusões de outras mecânicas (hooks), não duplicar regras de combate/quest.
