# Sistema: Combate PvE e PvP

## 1. Objetivo e escopo

- **Objetivo:** Dano, mitigação, agro PvE e regras de PvP por **zona**. Toda a resolução crítica ocorre no **servidor**; o client apenas feedback visual e raycasts auxiliares onde aplicável.
- **Fora de escopo:** Animlocks específicos por arma (implementação artística).

## 2. Fórmula base de dano

```
finalDamage = rawDamage
  * classMod
  * skillMod
  * weaponMod
  * (1 - mitigation)
  * zoneMod   -- ex.: safe = 0 vs jogadores
```

- `rawDamage` definido pelo recurso de combate no servidor (hit validator).
- **Mitigation:** função capada e.g. `mitigation = armor / (armor + K)`.

## 3. PvE — agro e NPC

- Cada NPC tem `aggroRadius`, `leashRadius`, `faction`.
- Agro: primeiro dano ou proximidade — lista `threatTable[npcId][src]`.
- **AI:** pode residir no client de cada jogador para performances **desde que** dano e morte sejam confirmados no servidor (modelo comum em FiveM para Bandits).

## 4. PvP por zona ([09-zonas-e-npc-hostis.md](09-zonas-e-npc-hostis.md))

| Zona | Comportamento |
|------|----------------|
| Verde (safe) | `finalDamage` jogador→jogador = 0; opcional bloqueio total de disparos |
| Amarela | PvP opcional por toggle ou sempre ligado conforme design |
| Vermelha | PvP pleno + possível loot jogador (se habilitado noutra spec) |

O core já tem flag global `QBConfig.Server.PVP` em `config.lua`; **sobrepor** com prioridade `zoneRules > global` no teu resource de combate.

## 5. Eventos e exports

| Export | Descrição |
|--------|-----------|
| `ApplyDamageToPed(attackerSrc, victimNetId, weapon, boneId)` | Servidor valida distância + LOS simplificado |
| `GetZoneCombatPolicy(src)` | Consulta cache de zona |

## 6. Dependências

- Classes ([02](02-classes.md)), Skill tree ([04](04-skill-tree.md)), Zonas ([09](09-zonas-e-npc-hostis.md))

## 7. Riscos

- Silent aim — validação server de ângulo/distância/bone rate limit.

## 8. Plano de teste

1. Dano entre jogadores em zona verde = 0.
2. NPC recebe dano e morre — loot dispara no servidor.
3. Rate limit de hits por segundo.
