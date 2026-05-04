# Stack e ferramentas

## Runtime

| Componente | Notas |
|------------|--------|
| **FXServer** (FiveM) | Artifacts recentes estáveis (equipe deve fixar versão em produção). Referência: `>= 7290` como linha base em muitos servidores; validar com o teu host. |
| **Lua 5.4** | Ativado no core via `lua54 'yes'` em `fxmanifest.lua`. |

## Base de dados

| Componente | Papel |
|------------|--------|
| **MariaDB / MySQL** | Persistência do servidor. Preferir MariaDB 10.6+ ou MySQL 8. |
| **oxmysql** | Driver oficial no ecossistema QB; `MySQL.*` API (await). Dependência declarada no `qb-core`. |

## Bibliotecas de jogo (recomendadas)

| Resource | Papel | Nota |
|----------|--------|------|
| **ox_lib** | Cache, zonas, progress bar, diálogos, notify, callbacks modernos | **Dependência transversal** recomendada para novos recursos `qbx-*`. |
| **PolyZone** ou zonas do **ox_lib** | Delimitar áreas (safe / perigo), triggers espaciais | Evitar scans globais sem intervalo. |
| **ox_target** | Interações olhar-tecla | Alternativa: **qb-target**. |

## Inventário e itens

| Opção | Quando usar |
|-------|-------------|
| **qb-inventory** | Já integrado no login do core (`LoadInventory` / `SaveInventory` em `server/player.lua`). |
| **ox_inventory** | Migração possível; exige alinhamento de itens e eventos; documentar em `09-recursos-externos.md`. |

## Outros resources comuns

| Resource | Papel |
|----------|--------|
| **qb-log** | Logs Discord / ficheiro (muitos exemplos no core com `qb-log:server:CreateLog`). |
| **qb-menu / qb-input** | Menus e formulários (se ainda usados no teu pack). |
| **progressbar** | Usado por `QBCore.Functions.Progressbar` no client (`client/functions.lua`). |
| **qb-banking / qb-management** | Sociedades e paycheck (opcional, conforme `config.lua`). |

## Ferramentas de desenvolvimento

| Ferramenta | Uso |
|------------|-----|
| **VS Code / Cursor** | Edição |
| **lua-language-server** | Análise estática, tipos @ |
| **cfxlua-vscode** (ou extensão FiveM) | Natives e snippets |
| **Stylua** | Formatação Lua |
| **Selene** | Linter Lua |
| **FxDK** | Prototipagem e testes locais |

## Mapas e zonas

- **PolyZone Creator** ou ferramentas no próprio jogo + export de coords para `config.lua`.
- **ox_lib** `lib.zones` / `lib.points` para pontos e caixas com callbacks.

## txAdmin

- Arranque do servidor, backups agendados, restarts — alinhar avisos aos jogadores antes de atualizar resources críticos (`qb-core`, inventário).
