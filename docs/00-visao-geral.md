# Visão geral

**Cidade:** o servidor opera sob a marca **Distopia**. Identidade visual, pack de logos e regras para NUI estão em [branding.md](branding.md).

## Objetivo

Servidor **GTA V / FiveM** com identidade de **sobrevivência** e profundidade de **MMORPG**: progressão (nível de personagem, classes, profissões), conteúdo (quests, loot, craft), risco (zonas, NPCs hostis, PvP condicional) e imersão (fome, sede, doenças, frio, sangramento), além de sistemas de longo prazo (passe de batalha, árvore de habilidades).

## O que é este repositório

Esta pasta de trabalho contém o pacote **`qb-core`** (framework QBCore). O core oferece:

- Objeto global `QBCore` e `GetCoreObject`
- Dados de jogador (`PlayerData`, `metadata` JSON persistido)
- Eventos e callbacks padrão
- Integração **oxmysql** e schema mínimo em `qbcore.sql`

**Regra de ouro:** novas mecânicas de jogo **não** alteram o código fonte do `qb-core` no dia a dia. Elas vivem em **resources separados** com prefixo sugerido **`qbx-`** (ex.: `qbx-zones`, `qbx-quests`) e integram o core via `exports`, `metadata` e tabelas SQL próprias.

## Princípios

1. **Servidor manda** — o cliente é considerado hostil para checagens de economia, XP, itens e progressão.
2. **Config em arquivo** — balanceamento em `config.lua`, não espalhado em código.
3. **Persistência clara** — poucos dados em `metadata`; volumes grandes em tabelas dedicadas com `citizenid`.
4. **Performance explícita** — zonas e sleeps conscientes; sem loops caros por frame.
5. **Documentação junto da feature** — spec em `docs/systems/` antes ou durante a implementação.

## Público desta documentação

- **Desenvolvedores humanos** — leem estes arquivos em PT-BR.
- **Agentes de IA** — seguem [`AGENTS.md`](../AGENTS.md) (EN) + `.cursor/rules/`.

## Referências externas oficiais

- [Documentação QBCore](https://docs.qbcore.org)
- [FiveM natives](https://docs.fivem.net/natives/)
- [Cfx.re docs](https://docs.fivem.net/)
