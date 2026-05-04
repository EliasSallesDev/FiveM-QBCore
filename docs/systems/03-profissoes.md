# Sistema: Profissões

## 1. Objetivo e escopo

- **Objetivo:** Progressão **económica/crafting** independente da classe de combate. Cada profissão tem **nível próprio** e **XP próprio**, desbloqueando receitas, bancadas ou zonas de recurso.
- **Fora de escopo:** Definição de cada receita em items.lua (documentar só contratos).

## 2. Profissões exemplo

| ID | Nome | Atividades |
|----|------|------------|
| `mining` | Mineração | Veios, pedreiras |
| `woodcutting` | Lenharia | Árvores marcadas |
| `herbalism` | Herborismo | Plantas, cogumelos |
| `fishing` | Pesca | Spots de água |
| `cooking` | Cozinha | Comida buff |
| `alchemy` | Alquimia | Poções, antídotos |
| `blacksmith` | Ferraria | Armas/armaduras metal |
| `gunsmith` | Mecânica de armas | Mods, reparo avançado |

## 3. Dados persistidos

### `PlayerData.metadata.professions`

Estrutura sugerida:

```lua
professions = {
  mining = { xp = 0, level = 1 },
  ...
}
```

Ou normalizado em SQL se precisares de rankings globais:

```sql
CREATE TABLE IF NOT EXISTS qbx_profession_progress (
  citizenid VARCHAR(50) NOT NULL,
  profession_id VARCHAR(32) NOT NULL,
  xp INT NOT NULL DEFAULT 0,
  level INT NOT NULL DEFAULT 1,
  PRIMARY KEY (citizenid, profession_id)
);
```

## 4. Ganho de XP

- **Gather:** servidor valida zona + ferramenta correta + yield.
- **Craft:** servidor valida receita, nível e mesa.

## 5. Integração

- **Loot/craft:** gates por nível ([06-loot-e-craft.md](06-loot-e-craft.md))
- **Quests:** objetivos `gather` ([05-quests.md](05-quests.md))

## 6. Exports

| Export | Descrição |
|--------|-----------|
| `AddProfessionXp(src, professionId, amount, reason)` | Servidor |
| `GetProfessionLevel(src, professionId)` | Servidor |

## 7. Riscos

- Macro gather — cooldown por árvore/veio **server-side** + random jitter.

## 8. Plano de teste

1. Gather válido dá XP; ferramenta errada não.
2. Craft bloqueado por nível.
3. Persistência após restart.
