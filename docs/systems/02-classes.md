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
| `id` | string | ID da classe |
| `rank` | int opcional | Prestígio dentro da classe (futuro) |
| `xp` | int | XP **da classe** (separado do personagem) |
| `level` | int | Nível da classe |

Troca de classe: **servidor**, custo em item moeda (`Config.ClassChangeCost`) + cooldown em **SQL ou metadata**.

## 4. Modificadores derivados

No servidor, ao aplicar dano/cura:

```
effectiveStat = baseStat * classMods.damage * skillMods * ...
```

Tabela `Config.ClassMods[classId]` com multiplicadores por `damage`, `mitigation`, `healing`, `staminaDrain`, etc.

## 5. Habilidades ativas

- Registar como **itens usáveis** (consumo de stamina/ cooldown server-side) **ou** `RegisterCommand` + keybind que pede ao servidor `TryUseAbility(abilityId)`.
- **Toda** habilidade valida classe atual + cooldown + recurso (mana/stamina inventário).

## 6. Eventos e exports

| Export | Descrição |
|--------|-----------|
| `GetClassId(src)` | Retorna id atual |
| `GetClassModifiers(src)` | Tabela de mods para combate |

## 7. Dependências

- Progressão global ([01-personagem-e-progressao.md](01-personagem-e-progressao.md))
- Combate ([07-combate-pve-pvp.md](07-combate-pve-pvp.md))

## 8. Riscos

- Troca de classe em combate — bloquear se em combate flag ou zona vermelha opcional.

## 9. Plano de teste

1. Escolha inicial de classe no criador ou NPC.
2. Modificadores aplicados em dano simulado servidor.
3. Troca com custo e cooldown respeitados.
