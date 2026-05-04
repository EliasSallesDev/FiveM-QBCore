# Documentação do servidor — MMORPG Sobrevivência (QBCore)

Índice da documentação em **português (PT-BR)**. Para agentes de IA (Cursor/Codex), o guia canônico em inglês está na raiz: [**`AGENTS.md`](../AGENTS.md)**.

## Visão geral

| Documento | Conteúdo |
|-----------|----------|
| [branding.md](branding.md) | Identidade da cidade Distopia, brand pack (`shared/Pack Logo Distopia/`) e regras de uso da logo em UI |
| [00-visao-geral.md](00-visao-geral.md) | Objetivo do projeto, princípios, o que é `qb-core` vs `qbx-*` |
| [01-arquitetura.md](01-arquitetura.md) | Camadas, diagrama, fluxo de dados |
| [02-stack-e-ferramentas.md](02-stack-e-ferramentas.md) | FXServer, oxmysql, ox_lib, inventário, targeting, tooling |
| [03-padroes-de-codigo.md](03-padroes-de-codigo.md) | Nomenclatura, estrutura de resource, metadata, statebags |
| [04-fluxo-de-implementacao.md](04-fluxo-de-implementacao.md) | Do desenho à entrega (spec → código → DoD) |
| [05-performance-e-otimizacao.md](05-performance-e-otimizacao.md) | Budgets, anti-padrões, profilers |
| [06-seguranca-e-anti-cheat.md](06-seguranca-e-anti-cheat.md) | Autoridade no servidor, eventos proibidos, rate limit |
| [07-banco-de-dados.md](07-banco-de-dados.md) | oxmysql, migrations, convenções |
| [08-testes-e-qa.md](08-testes-e-qa.md) | Testes manuais, FxDK, smoke test |
| [09-recursos-externos.md](09-recursos-externos.md) | Matriz de dependências do ecossistema QBCore |

## Especificações de sistemas (gameplay)

Todas em [systems/](systems/); comece por [systems/00-overview.md](systems/00-overview.md) (matriz de dependências).

| # | Spec |
|---|------|
| 01 | [Personagem e progressão](systems/01-personagem-e-progressao.md) |
| 02 | [Classes](systems/02-classes.md) |
| 03 | [Profissões](systems/03-profissoes.md) |
| 04 | [Árvore de habilidades](systems/04-skill-tree.md) |
| 05 | [Quests](systems/05-quests.md) |
| 06 | [Loot e craft](systems/06-loot-e-craft.md) |
| 07 | [Combate PvE/PvP](systems/07-combate-pve-pvp.md) |
| 08 | [Sangramento e status](systems/08-sangramento-e-status.md) |
| 09 | [Zonas e NPCs hostis](systems/09-zonas-e-npc-hostis.md) |
| 10 | [Sobrevivência (fome, sede, doenças, frio)](systems/10-survival-fome-sede-doencas-frio.md) |
| 11 | [Passe de batalha](systems/11-battle-pass.md) |

## Modelos

- [templates/feature-spec-template.md](templates/feature-spec-template.md) — template de especificação
- [templates/resource-skeleton/](templates/resource-skeleton/) — esqueleto de resource `qbx-*`

## Regras do Cursor

Regras em [`.cursor/rules/`](../.cursor/rules/) (inglês, escopo por glob).
