# Sistema: Personagem e progressão (nível global)

## 1. Objetivo e escopo

- **Objetivo:** Definir **nível de personagem** e **XP de personagem** separados de XP de **classe** e de **profissão**. O nível global abre teto de skill points, slots de conteúdo e gates suaves.
- **Fora de escopo:** Balance fino de cada classe (ver [02-classes.md](02-classes.md)); crafting detalhado ([06-loot-e-craft.md](06-loot-e-craft.md)).

## 2. Dados persistidos

### 2.1 `PlayerData.metadata.character` (objeto)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `level` | int | Nível global (≥ 1) |
| `xp` | int | XP acumulado no nível atual |
| `skillPoints` | int | Pontos para gastar na árvore (ver [04-skill-tree.md](04-skill-tree.md)) |
| `statAlloc` | table opcional | Se usares atributos livres (FOR/DEX/…) |

Valores default aplicados no primeiro login via merge em `PlayerDefaults` **num resource qbx** com `AddEventHandler('QBCore:Server:PlayerLoaded')` + defaults seguros se campos faltarem.

### 2.2 SQL opcional (histórico / anti-tamper)

```sql
CREATE TABLE IF NOT EXISTS qbx_character_progress_audit (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  citizenid VARCHAR(50) NOT NULL,
  delta_xp INT NOT NULL,
  reason VARCHAR(64) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  KEY idx_citizenid_time (citizenid, created_at)
);
```

Opcional; só se precisares de auditoria ou leaderboard semanal.

## 3. Fórmulas

- **XP para o próximo nível** (tunable):

\[
\text{xpToNext}(L) = \text{round}\bigl( \text{Config.XpBase} \times L^{1.7} \bigr)
\]

- **Subir de nível:** enquanto `xp >= xpToNext(level)`, subtrair `xpToNext`, incrementar `level`, acumular `skillPoints += Config.SkillPointsPerLevel` (e notificar).
- **Ganho de XP:** sempre no **servidor** após validação da origem (kill, quest, gather, etc.).

## 4. Eventos e exports

| Export | Args | Retorno |
|--------|------|---------|
| `GrantCharacterXp` | `src, amount, reason` | `boolean` |
| `GetCharacterProgress` | `src` | `{ level, xp, xpToNext, skillPoints }` |

Eventos internos (servidor):

- `qbx-progression:server:grantXp` — outros sistemas pedem XP com motivo curto (`reason` enum).

## 5. Config exemplo (`config.lua`)

```lua
Config.XpBase = 120
Config.SkillPointsPerLevel = 1
Config.MaxLevel = 80 -- 0 = sem cap
```

## 6. Dependências

- `qb-core`
- Consumido por: classes, skill tree, battle pass

## 7. Riscos e anti-cheat

- **Nunca** aceitar quantidade de XP do cliente sem validação.
- Rate-limit ganhos por `reason` (ex.: mesmo mob farm).

## 8. Plano de teste

1. Novo personagem com defaults corretos.
2. `GrantCharacterXp` até subir 2 níveis — skill points aumentam.
3. Persistência após reconectar.
4. Tentativa de trigger de evento falso (deve falhar / ignorar).
