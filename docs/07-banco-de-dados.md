# Base de dados

## Driver: oxmysql

O `qb-core` já inclui `@oxmysql/lib/MySQL.lua`. API típica:

| Operação | Exemplo |
|----------|---------|
| Query única | `MySQL.single.await('SELECT ... WHERE citizenid = ?', { cid })` |
| Prepare | `MySQL.prepare.await` para statements repetidos |
| Insert | `MySQL.insert.await(...)` |
| Transação | `MySQL.transaction(queries, function(success) ... end)` |

Evitar **`mysql-async`**.

## Convenções de schema

| Regra | Detalhe |
|-------|---------|
| Chave de jogador | `citizenid` VARCHAR — PK lógica do QBCore |
| Nomes de tabela | `snake_case`, prefixo do sistema opcional `qbx_<feature>_...` |
| Índices | `citizenid`, `quest_id`, `season_id` conforme queries reais |
| JSON | Usar coluna JSON só quando o schema for flexível; **evitar** `JSON_EXTRACT` em hot path — desnormalizar campos filtrados |

## Migrations

1. Ficheiros numerados: `sql/0001_init.sql`, `sql/0002_add_x.sql`.
2. Idempotência: `CREATE TABLE IF NOT EXISTS`, `ALTER TABLE ... ADD COLUMN IF NOT EXISTS` (sintaxe depende do motor — validar na tua versão MariaDB/MySQL).
3. Opcional: tabela `_migrations` no servidor para tracking.

## Relação com `players`

- O core guarda `metadata` em texto JSON na tabela `players` ([`qbcore.sql`](../qbcore.sql)).
- **Preferir** não alterar colunas do core; para dados grandes ou relacionais, **novas tabelas** com `citizenid`.

## Backups

- Backup automático diário (txAdmin ou cron dump).
- Retenção sugerida: 7 dias mínimo em produção.
- Testar restore em ambiente de staging antes de migrações grandes.
