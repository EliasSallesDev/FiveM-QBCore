# Sistema: Quests

## 1. Objetivo e escopo

- **Objetivo:** Missões com máquina de estados, progresso persistido, tipos variados e resets **daily/weekly** onde aplicável.
- **Fora de escopo:** Narrativa completa — apenas contrato técnico.

## 2. Tipos de quest

| Tipo | Descrição |
|------|-----------|
| `kill` | Matar N entidades (NPC tipo Z ou jogador em zona PvP se permitido) |
| `gather` | Obter N itens via gather válido |
| `escort` | Acompanhar NPC ao longo de rota |
| `discover` | Entrar em zona / marco |
| `deliver` | Entregar itens a NPC |
| `survive` | Permanecer X tempo com condição (fome, clima) |

## 3. Dados persistidos

### Catálogo (estático)

Ficheiro `shared/quests.lua` ou DB `qbx_quests_catalog`:

| Coluna | Uso |
|--------|-----|
| `quest_id` | PK string |
| `type` | Enum acima |
| `objectives` | JSON esquema por tipo |
| `rewards` | XP personagem, XP classe, itens, BP XP |

### Progresso jogador

```sql
CREATE TABLE IF NOT EXISTS qbx_player_quests (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  citizenid VARCHAR(50) NOT NULL,
  quest_id VARCHAR(64) NOT NULL,
  state ENUM('active','completed','failed','abandoned') NOT NULL,
  progress JSON NOT NULL,
  started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  completed_at TIMESTAMP NULL,
  UNIQUE KEY uniq_active (citizenid, quest_id),
  KEY idx_citizenid (citizenid)
);
```

## 4. Fluxo

1. **Aceitar:** servidor verifica prereqs (nível, classe, zona).
2. **Atualizar progresso:** apenas servidor em hooks (`entityKilled`, `itemAdded`, etc.).
3. **Completar:** recompensas no servidor, marcar `completed`, disparar hooks battle pass.

## 5. Daily / Weekly

- Tabela `qbx_quest_rotations` com `period_start`, `quest_pool JSON`.
- Cron servidor (timer ou ao primeiro login do dia) para rerolar seeds **server-side**.

## 6. Dependências

- Targeting para NPCs (`ox_target`)
- Zonas ([09-zonas-e-npc-hostis.md](09-zonas-e-npc-hostis.md))

## 7. Riscos

- Duplo claim de recompensa — usar transação SQL ou flag única `claimed`.

## 8. Plano de teste

1. Aceitar, progresso incremental, completar.
2. Abandonar e reaceitar se permitido.
3. Daily reroll com relógio simulado.
