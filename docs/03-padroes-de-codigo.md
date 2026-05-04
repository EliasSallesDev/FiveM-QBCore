# Padrões de código

## Nomenclatura

| Tipo | Convenção | Exemplo |
|------|-------------|---------|
| Resource | kebab-case com prefixo | `qbx-zones`, `qbx-quests` |
| Ficheiros Lua | snake_case | `spawn_manager.lua`, `api.lua` |
| Funções locais | camelCase ou PascalCase consistente no resource | `getZoneTierAtCoords` |
| Eventos de rede | namespace do resource + lado + verbo | `qbx-zones:server:enteredZone` |
| Exports públicos | verbos claros | `exports['qbx-zones']:GetPlayerZoneTier(src)` |

## Estrutura de um resource `qbx-*`

Ver esqueleto em [templates/resource-skeleton/](templates/resource-skeleton/). Resumo:

```
qbx-<feature>/
  fxmanifest.lua
  config.lua
  shared/main.lua
  server/main.lua
  server/api.lua          # exports
  server/events.lua
  server/callbacks.lua
  server/db.lua
  client/main.lua
  client/events.lua
  locale/en.lua
  locale/pt-br.lua
  sql/0001_init.sql
  html/                   # opcional
```

## QBCore

- Sempre `local QBCore = exports['qb-core']:GetCoreObject()` no topo dos ficheiros que precisam (ou guard em `main.lua`).
- Obter jogador: `local Player = QBCore.Functions.GetPlayer(src)` — tratar `nil`.
- Atualizar dados persistidos do personagem: `Player.Functions.SetMetaData('chave', valor)` para campos dentro de `metadata`.

## Locale

- Nenhuma string visível ao jogador **hardcoded** em Lua de produção.
- Usar `Lang:t('chave')` com ficheiros em `locale/` (padrão QB) ou o sistema do teu pack.
- Chaves estáveis: `feature.section.action`.

## Onde guardar dados

| Dado | Onde |
|------|------|
| Flags pequenas, frequentes (nível resumido, toggles) | `PlayerData.metadata.<feature>` |
| Estado runtime replicado (zona atual, debuff ativo para HUD) | `Player(src).state` |
| Listas grandes, histórico, relações N:N | Tabelas SQL com `citizenid` |

## Configuração

- Todo o balanceamento em **`config.lua`**: multiplicadores de XP, raio de zona, cooldowns.
- Para vários ambientes (dev/prod), usar ConVars ou ficheiros separados **nunca** commitados com secrets.

## Eventos depreciados (não usar em código novo)

Ver [06-seguranca-e-anti-cheat.md](06-seguranca-e-anti-cheat.md). Em especial: eventos de `UseItem` / `AddItem` / `RemoveItem` no core.

## Branding em UI (Distopia)

- Toda **NUI** (`html/` + `ui_page`) deve incluir a marca **Distopia**: **favicon** + **logo visível** no cabeçalho (e splash/loading quando aplicável).
- Diretrizes completas, mapeamento de ficheiros do pack e snippets: [branding.md](branding.md).
- **Convenção de pasta** no resource que tenha UI:

```
html/assets/brand/
  logo-96.png      # favicon (copiado do pack, nome normalizado)
  logo-512.png     # header
  logo-2000.png    # watermark / fundo (opcional)
  loading.gif      # ecrã de carregamento (opcional)
```

Copiar a partir de [`shared/Pack Logo Distopia/`](../shared/Pack%20Logo%20Distopia/) e listar `html/assets/brand/**` em `files { }` no `fxmanifest.lua`.
