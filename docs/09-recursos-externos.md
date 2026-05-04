# Recursos externos (matriz)

Versões são **orientativas** — fixa sempre a versão testada no teu `server.cfg` / artefactos e atualiza esta tabela quando atualizares.

| Resource | Versão ref. | Licença | Papel | Alternativa |
|----------|-------------|---------|-------|-------------|
| **qb-core** | 1.3.x | GPL-3.0 | Framework base | ESX (outro ecossistema) |
| **oxmysql** | atual | MIT/GPL conforme repo | MySQL driver | — |
| **ox_lib** | atual | LGPL/MIT conforme repo | UI, cache, zonas, callbacks | oxmysql + libs dispersas |
| **ox_target** | atual | conforme repo | Targeting 3D | qb-target |
| **qb-target** | legado | conforme repo | Targeting | ox_target |
| **qb-inventory** | conforme pack | conforme repo | Inventário stash/player | ox_inventory |
| **ox_inventory** | conforme repo | conforme repo | Inventário moderno | qb-inventory |
| **qb-menu** | conforme pack | conforme repo | Menus contextuais | ox_lib context |
| **qb-input** | conforme pack | conforme repo | Form inputs | ox_lib input |
| **qb-log** | conforme pack | conforme repo | Logs Discord/arquivo | logger custom |
| **PolyZone** | conforme repo | MIT | Zonas legadas | ox_lib zones |
| **progressbar** | conforme pack | conforme repo | Barras de progresso | ox_lib progress |
| **qb-banking** | opcional | conforme repo | Contas job | qs-banking / custom |
| **qb-phone** | opcional | conforme repo | Telefone RP | lb-phone / custom |
| **pma-voice** | atual | conforme repo | Voice chat | mumble-voip / SaltyChat |
| **screenshot-basic** | opcional | conforme repo | Screenshots / reports | — |

## Obrigatórios para o plano MMORPG deste projeto

- **ox_lib** — adotado como dependência transversal (zonas, notify, utilitários).
- **ox_target** ou **qb-target** — interações.
- **qb-inventory** (atual do core) ou migração planeada para **ox_inventory**.

## Links (descoberta)

- QBCore: <https://github.com/qbcore-framework>
- overextended (ox_*): <https://github.com/overextended>
- FiveM docs: <https://docs.fivem.net/>

Atualizar esta página sempre que adicionares um resource ao `server.cfg`.
