# Sistema: Passe de batalha (Battle Pass)

## 1. Objetivo e escopo

- **Objetivo:** Temporadas com **níveis** (ex.: 100), faixas **free** e **premium**, progresso por **XP de passe** ganho em atividades do mundo (NPC tier alto, quests, missões diárias/semanais).
- **Fora de escopo:** Monetização real — apenas estrutura técnica.

## 2. Dados persistidos

### Temporadas

```sql
CREATE TABLE IF NOT EXISTS qbx_bp_seasons (
  season_id VARCHAR(32) PRIMARY KEY,
  starts_at TIMESTAMP NOT NULL,
  ends_at TIMESTAMP NOT NULL,
  meta JSON NOT NULL
);
```

### Progresso jogador

```sql
CREATE TABLE IF NOT EXISTS qbx_bp_progress (
  citizenid VARCHAR(50) NOT NULL,
  season_id VARCHAR(32) NOT NULL,
  tier SMALLINT NOT NULL DEFAULT 0,
  xp INT NOT NULL DEFAULT 0,
  premium TINYINT NOT NULL DEFAULT 0,
  claimed_free JSON NOT NULL,   -- array de tiers reclamados
  claimed_premium JSON NOT NULL,
  PRIMARY KEY (citizenid, season_id)
);
```

### Missões dinâmicas (daily/weekly)

```sql
CREATE TABLE IF NOT EXISTS qbx_bp_missions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  citizenid VARCHAR(50) NOT NULL,
  season_id VARCHAR(32) NOT NULL,
  period ENUM('daily','weekly') NOT NULL,
  seed VARCHAR(64) NOT NULL,
  mission_def JSON NOT NULL,
  progress JSON NOT NULL,
  completed_at TIMESTAMP NULL,
  KEY idx_lookup (citizenid, season_id, period)
);
```

## 3. Geração por seed

- Para cada jogador e período: `seed = hash(citizenid, season_id, periodKey)` para escolher 3 missões de um pool sem armazenar RNG frágil no client.

## 4. Hooks (servidor)

Disparar ganhos de XP de passe apenas **depois** da ação validada:

| Origem | Exemplo de XP |
|--------|----------------|
| Kill NPC tier red | +50 |
| Quest story completa | +200 |
| Daily mission | conforme def |

Evento interno sugerido: `qbx-battlepass:server:addXp(src, amount, reason)`.

## 5. Recompensas

- **Claim:** servidor verifica `tier` desbloqueado e marca JSON `claimed_*`; entrega itens via inventário API.

## 6. Dependências

- Progressão ([01](01-personagem-e-progressao.md)), Quests ([05](05-quests.md)), Zonas/NPC ([09](09-zonas-e-npc-hostis.md))

## 7. Riscos

- Duplo claim — transação SQL ou `UPDATE ... WHERE tier_claimed < targetTier`.

## 8. Plano de teste

1. Season ativa — XP incrementa e sobe tier.
2. Premium flag off — não reclama track premium.
3. Reset diário gera novas missões determinísticas com mesmo seed.
