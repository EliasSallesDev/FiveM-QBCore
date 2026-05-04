# Fluxo de implementação

Use este fluxo para **qualquer** feature nova (classe, zona, quest, item, UI).

## 1. Especificação

1. Copiar [templates/feature-spec-template.md](templates/feature-spec-template.md).
2. Guardar em `docs/systems/` com nome claro (ou atualizar spec existente).
3. Preencher: objetivo, dados persistidos, eventos/exports, riscos, plano de teste.

## 2. Scaffold do resource

1. Copiar [templates/resource-skeleton/](templates/resource-skeleton/) para `resources/[standalone]/qbx-<nome>/` no teu servidor real (este repositório pode só ter docs — o caminho final é no servidor FiveM).
2. Ajustar `fxmanifest.lua`: nome, descrição, `dependencies`.
3. Registar o resource em `server.cfg` **depois** de `qb-core` e dependências (oxmysql, ox_lib, etc.).

## 3. Schema (se necessário)

1. Criar `sql/0001_*.sql` com `CREATE TABLE IF NOT EXISTS`.
2. Chaves estrangeiras lógicas por **`citizenid`** (string QB).
3. Documentar no README do resource e na spec.
4. Executar migration na base de desenvolvimento; backup antes em produção.

## 4. Implementação server-first

1. Handlers de `QBCore:Server:PlayerLoaded` / unload para carregar e gravar estado.
2. Validação de todas as ações sensíveis no servidor.
3. `QBCore.Functions.CreateCallback` para pedidos que precisam de resposta.
4. Exports documentados em `server/api.lua`.

## 5. Client

1. Threads com `Wait` adequado; zonas com ox_lib/PolyZone.
2. Pontes para NUI se existir UI.
3. Nunca aplicar XP/dano/recompensa final só no client.

## 6. Locale e config

1. Todas as strings em `locale/en.lua` e `locale/pt-br.lua`.
2. Números e tempos só em `config.lua`.

## 7. Definition of Done

1. Checklist do [`.github/pull_request_template.md`](../.github/pull_request_template.md).
2. Atualizar [systems/00-overview.md](systems/00-overview.md) se houver novas dependências entre sistemas.
3. Atualizar [09-recursos-externos.md](09-recursos-externos.md) se entrar dependência nova.

## 8. Rollout

1. `ensure qbx-<nome>` após testes em staging.
2. Comunicar restart curto se tocar em DB ou core hooks partilhados.
