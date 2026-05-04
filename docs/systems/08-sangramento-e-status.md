# Sistema: Sangramento e status

## 1. Objetivo e escopo

- **Objetivo:** Status negativos **stackáveis** (sangramento), cura por tempo com **bandagens** por tier, doenças com tick independente.
- **Integração:** Combate ([07](07-combate-pve-pvp.md)), Survival ([10](10-survival-fome-sede-doencas-frio.md)).

## 2. Sangramento

- **Stacks:** 1–5. Cada stack aplica DoT por segundo: `damagePerTick = Config.BleedDamageBase * stacks`.
- **Fonte:** críticos de arma/corte (servidor decide aplicar stack).
- **Cura:** item `bandage_t1` cancela 1 stack por tick de canalização; `bandage_t3` remove todos — tempo de canalização em config.

### Metadata sugerida

```lua
metadata.status = metadata.status or {}
metadata.status.bleed = { stacks = 0, until_ts = 0 } -- ou só stacks + timer servidor
```

Ou statebag `bleedStacks` para HUD.

## 3. Doenças (subset)

| ID | Contrato | Efeito |
|----|----------|--------|
| `flu` | tick servidor | stamina drain |
| `infection` | após bleed longo | HP drain leve |
| `radiation` | zonas vermelhas especiais | acumula dose |

Guardar em `metadata.status.diseases = { flu = { severity = 2 } }`.

## 4. Tick servidor

- Um timer por jogador ou batch global a cada 1–5 s processando só jogadores com status ativos (performance).

## 5. Eventos

- `qbx-status:server:applyBleed(src, stacksToAdd, reason)`
- `qbx-status:server:cureDisease(src, diseaseId)`

## 6. Riscos

- Curar sem consumível — sempre remover item no servidor.

## 7. Plano de teste

1. Aplicar bleed — HP desce previsível.
2. Bandagem interrompida não cura.
3. Doença persiste reconnect se guardada em metadata.
