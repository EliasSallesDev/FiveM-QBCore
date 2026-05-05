# Sistema: Classes

## 1. Objetivo e escopo

- **Objetivo:** Catálogo de **classes de combate/survival** com modificadores derivados e habilidades ativas. Classes são ortogonais a **profissões** (economia/craft).
- **Fora de escopo:** Profissões ([03-profissoes.md](03-profissoes.md)); árvore completa ([04-skill-tree.md](04-skill-tree.md)).

## 2. Catálogo inicial (exemplo — tunável)

| ID | Nome PT | Papel | Notas |
|----|---------|-------|-------|
| `warrior` | Guerreiro | Tanque / corpo a corpo | +mitigação |
| `hunter` | Caçador | Dano à distância / tracking | +precisão |
| `medic` | Médico | Suporte / cura | +cura |
| `survivor` | Sobrevivente | Utilidade / resistência | balance genérico |
| `engineer` | Engenheiro | Craft de campo / torretas leves | liga a profissões |

## 3. Dados persistidos

### `PlayerData.metadata.class`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `id` | string | ID da classe ativa |
| `lastChangedAt` | int | Timestamp da última troca |
| `selectedAt` | int | Timestamp da primeira escolha real |
| `hasChosenClass` | bool | Se o jogador já fez a escolha inicial |

### `PlayerData.metadata.classes[classId]`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `rank` | int opcional | Prestígio dentro da classe (futuro) |
| `xp` | int | XP **da classe** (separado do personagem e das outras classes) |
| `level` | int | Nível da classe |
| `abilityCooldowns` | table | Cooldowns server-side por habilidade |
| `abilityActives` | table | Timestamps de fim do efeito ativo por habilidade |

Troca de classe: **servidor**, primeira escolha sem item. Depois disso o jogador so troca usando `Config.ClassChangeItem`; o item e consumido na troca.

## 4. Modificadores derivados

No servidor, ao aplicar dano/cura:

```
effectiveStat = baseStat * classMods.damage * skillMods * ...
```

Tabela `Config.ClassMods[classId]` com multiplicadores por `damage`, `mitigation`, `healing`, `staminaDrain`, etc.

## 5. Habilidades ativas

- Registar como **itens usáveis** (consumo de stamina/ cooldown server-side) **ou** `RegisterCommand` + keybind que pede ao servidor `TryUseAbility(abilityId)`.
- **Toda** habilidade valida classe atual + cooldown + recurso (mana/stamina inventário).
- Recursos de habilidade entram por hooks server-side (`Config.AbilityResourceCheck` / `Config.AbilityResourceConsume`) para plugar `qbx-status` ou survival sem acoplar classes.

## 6. Eventos e exports

| Export | Descrição |
|--------|-----------|
| `GetClassId(src)` | Retorna id atual |
| `GetClassModifiers(src)` | Tabela de mods para combate |

UI inicial:

- `/classes` abre HUD NUI com classe atual, lista de classes, detalhes, confirmacao e habilidades.
- `/chooseclass` abre direto a lista de classes.
- Hotkey configurada em `Config.AbilityHotkey` usa a habilidade ativa da classe atual.

## 7. Dependências

- Progressão global ([01-personagem-e-progressao.md](01-personagem-e-progressao.md))
- NUI do resource para HUD inicial de selecao
- Combate ([07-combate-pve-pvp.md](07-combate-pve-pvp.md))

## 8. Riscos

- Troca de classe em combate — bloquear se em combate flag ou zona vermelha opcional.

## 9. Plano de teste

1. Escolha inicial de classe no criador ou NPC.
2. Modificadores aplicados em dano simulado servidor.
3. Troca bloqueada sem `class_change_token` e permitida uma vez quando o item existe.
