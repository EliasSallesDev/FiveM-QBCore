# qbx-progression

Sistema server-authoritative de nivel global e XP de personagem para Distopia.

## Dependencias

- `qb-core`
- `oxmysql`

## Persistencia

- `PlayerData.metadata.character.level`
- `PlayerData.metadata.character.xp`
- `PlayerData.metadata.character.skillPoints`
- `PlayerData.metadata.character.statAlloc`

Auditoria opcional:

- `sql/0001_progress_audit.sql`
- `qbx_character_progress_audit`

## Exports

```lua
local ok, result = exports['qbx-progression']:GrantCharacterXp(src, amount, reason)
local progress = exports['qbx-progression']:GetCharacterProgress(src)
```

`reason` deve existir em `Config.AllowedReasons`.

## Eventos

- `qbx-progression:server:grantXp` (interno do servidor: `TriggerEvent(name, src, amount, reason)`)
- `qbx-progression:server:progressUpdated`
- `qbx-progression:server:requestProgress`
- `qbx-progression:client:progress`
- `qbx-progression:client:progressUpdated`

O ganho de XP nao e registrado como evento de rede. Outros recursos devem preferir o export `GrantCharacterXp` depois de validar a acao no servidor.

## Comandos admin

```text
/grantcharxp <playerId> <amount> <reason>
```

O comando usa permissao QBCore `admin` e cria ACE `command.grantcharxp`.

## Instalacao

1. Execute `sql/0001_progress_audit.sql` na base de desenvolvimento se quiser habilitar `Config.AuditEnabled = true`.
2. Mantenha o resource em `resources/[qbx]/qbx-progression`.
3. Garanta `ensure qbx-progression` antes dos resources que consomem XP global, como `qbx-classes`.
