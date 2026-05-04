# Sistema: Sobrevivência — fome, sede, doenças, frio

## 1. Objetivo e escopo

- **Objetivo:** Estender o loop já existente no core (`QBCore:UpdatePlayer` em `server/events.lua` decrementa fome/sede; `client/loops.lua` aplica dano local quando zerados) com **temperatura**, **molhado**, **doenças** e integração com zonas/clima.
- **Nota:** O core já usa `metadata.hunger` / `metadata.thirst` — **reutilizar** nomes.

## 2. Campos novos em `metadata` (sugestão)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `temperature` | float | Valor normalizado ou Celsius interno |
| `wetness` | float 0–100 | Afeta frio e hipotermia |
| `disease` | table | Ver [08-sangramento-e-status.md](08-sangramento-e-status.md) |

## 3. Tick

- **Opção A:** Hook no evento existente `QBCore:UpdatePlayer` com **cuidado** para não duplicar saves — preferir um único recurso `qbx-survival` que subscreve e chama `SetMetaData` uma vez por ciclo.
- Intervalos de fome/sede já definidos em `QBConfig.Player.HungerRate`, `ThirstRate`, `StatusInterval`.

## 4. Frio

```
coldStress += (ambientCold * (1 - clothingInsulation) * (1 + wetness/100)) * dt
```

- `ambientCold` derivado de **zona** ([09](09-zonas-e-npc-hostis.md)) + **clima** (native ou sincronizado pelo recurso de weather).
- `clothingInsulation` lookup por componentes do ped (servidor pode pedir snapshot ao client via callback ocasional).

## 5. Doenças

- Contrato em [08](08-sangramento-e-status.md). Gatilhos: água não tratada, feridas abertas (bleed), zonas contaminadas.

## 6. Dependências

- Core (`metadata`)
- Zonas

## 7. Riscos

- Client reportar temperatura corporal — usar modelo simplificado **servidor** para penalidades finais.

## 8. Plano de teste

1. Fome/sede continuam a persistir após `/logout`.
2. Roupa pesada reduz hipotermia.
3. Molhado acelera frio.
