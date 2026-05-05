# qbx-classes

Sistema server-authoritative de classes de combate/survival para Distopia.

## Dependencias

- `qb-core`
- `qbx-progression`
- `qb-inventory` ou `ox_inventory` somente se `Config.ClassChangeCost.enabled = true`

## Persistencia

- `PlayerData.metadata.class.id`
- `PlayerData.metadata.class.lastChangedAt`
- `PlayerData.metadata.class.selectedAt`
- `PlayerData.metadata.class.hasChosenClass`
- `PlayerData.metadata.classes[classId].rank`
- `PlayerData.metadata.classes[classId].xp`
- `PlayerData.metadata.classes[classId].level`
- `PlayerData.metadata.classes[classId].abilityCooldowns`
- `PlayerData.metadata.classes[classId].abilityActives`

O cooldown de troca e o progresso por classe usam metadata, entao nao ha migration SQL nesta fase. O resource migra automaticamente o formato anterior `metadata.class.xp/level/rank` para `metadata.classes[activeClass]` no proximo `PlayerLoaded`.

## Exports

```lua
local classId = exports['qbx-classes']:GetClassId(src)
local modifiers = exports['qbx-classes']:GetClassModifiers(src)
local classData = exports['qbx-classes']:GetClassData(src)

local ok, result = exports['qbx-classes']:SetPlayerClass(src, 'warrior', false)
local ok, result = exports['qbx-classes']:GrantClassXp(src, amount, 'combat')
local ok, ability = exports['qbx-classes']:TryUseAbility(src, 'guard_stance')
```

`reason` deve existir em `Config.AllowedReasons`.

## Eventos

- `qbx-classes:server:setClass` (interno do servidor: `TriggerEvent(name, src, classId, force)`)
- `qbx-classes:server:grantXp` (interno do servidor: `TriggerEvent(name, src, amount, reason)`)
- `qbx-classes:server:requestClass`
- `qbx-classes:server:requestClassChange`
- `qbx-classes:server:tryUseAbility`
- `qbx-classes:server:classUpdated`
- `qbx-classes:server:classXpGranted`
- `qbx-classes:server:abilityUsed`
- `qbx-classes:client:classData`
- `qbx-classes:client:classUpdated`
- `qbx-classes:client:abilityUsed`

Troca de classe, XP e habilidades sao validados no servidor. Outros resources devem preferir exports depois de validar a acao que gerou a recompensa.

## Habilidades e recursos

`TryUseAbility` valida classe, nivel, cooldown e dois hooks configuraveis:

```lua
Config.AbilityResourceCheck = function(src, ability, classData)
    return true
end

Config.AbilityResourceConsume = function(src, ability, classData)
    return true
end
```

Use esses hooks para integrar stamina, mana, status ou inventario quando `qbx-status`/survival entrar. Retorne `false, 'ability_resource_unavailable'` para bloquear sem consumir cooldown.

## Comandos

```text
/classes
/chooseclass
/classabilityquick
/class
/classability <abilityId>
/setclass <playerId> <classId>
/grantclassxp <playerId> <amount> <reason>
```

`/classes` e `/chooseclass` abrem a HUD NUI com status, escolha de classe, detalhes, confirmacao e habilidades.
`/classabilityquick` usa a habilidade ativa da classe atual e fica mapeado por padrao na tecla definida em `Config.AbilityHotkey.defaultKey`.

`setclass` e `grantclassxp` usam permissao QBCore `admin` e criam ACEs `command.setclass` / `command.grantclassxp`.

## HUD NUI

Arquivos em `html/` implementam a HUD de classes. Como o pack oficial de logos Distopia nao esta presente neste checkout, `html/assets/brand/` inclui um fallback SVG (`logo.svg` / `favicon.svg`). Substitua por assets oficiais normalizados quando o pack estiver disponivel.

A HUD tambem inclui um widget compacto persistente para habilidade ativa, com estado pronta/ativa/recarregando e contagem regressiva.

## Token de troca

Depois da primeira escolha, o jogador so pode trocar de classe com `class_change_token`. O resource registra uma definicao runtime em `QBCore.Shared.Items` se o item nao existir e consome `Config.ClassChangeItem.amount` na troca validada pelo servidor.

Com `Config.SingleClassOnly = true`, trocar de classe reinicia o progresso das demais classes para manter apenas uma escolha efetiva por jogador.

## Instalacao

1. Mantenha `qbx-progression` e `qbx-classes` em `resources/[qbx]/`.
2. Garanta `ensure qbx-progression` antes de `ensure qbx-classes`.
3. Ajuste `Config.ClassChangeItem` se quiser renomear o token consumivel de troca de classe.
4. Use os exports de modificadores em `qbx-combat` quando o sistema de combate for implementado.
