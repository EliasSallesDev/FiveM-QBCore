# Segurança e anti-cheat

## Modelo de confiança

- **Cliente não é confiável.** Qualquer `RegisterNetEvent` pode ser disparado por exploits ou injectors.
- Toda a **economia, XP, níveis, inventário, loot final, conclusão de quest** deve ser decidida no **servidor**.

## Padrão de handler seguro

```lua
RegisterNetEvent('qbx-feature:server:action', function(payload)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    -- validar payload (tipos, ranges)
    -- validar distância a entidades / zonas
    -- validar cooldown / HasItem / permissões
    -- aplicar efeito e log opcional
end)
```

## Rate limiting

Para ações repetíveis (loot, craft, disparo de skill):

- Manter `lastAction[src] = os.time()` ou contadores por janela deslizante.
- Rejeitar silenciosamente ou com mensagem genérica — não revelar thresholds exatos.

## Distância e linha de visão

- Para interações físicas, calcular distância no servidor entre `GetEntityCoords(GetPlayerPed(src))` e alvo autorizado.
- Não confiar em coords enviadas pelo client sem validação cruzada.

## Eventos depreciados no QBCore

**Não ligar código novo** a estes eventos (marcados como deprecados / exploráveis em `server/events.lua` e `client/events.lua`):

| Evento | Motivo |
|--------|--------|
| `QBCore:Server:UseItem` | Exploitável |
| `QBCore:Server:AddItem` | Exploitável |
| `QBCore:Server:RemoveItem` | Exploitável |
| `QBCore:Client:UseItem` | Deprecado |

Usar o fluxo do **qb-inventory** / **ox_inventory**: hooks server-side, `CreateUseableItem` no servidor, etc.

## ExploitBan

O core exporta `ExploitBan` via [`server/exports.lua`](../server/exports.lua). Usar apenas quando a política do servidor permitir ban automático; caso contrário, kick + log + revisão humana.

## Logs

- Integrar **qb-log** (se disponível) para ações administrativas e suspeitas.
- Nunca logar dados pessoais reais fora do necessário.

## ACE / permissões

- Comandos de debug: `IsPlayerAceAllowed(src, 'qbadmin.allow')` ou grupo definido em `QBConfig.Server.Permissions`.
