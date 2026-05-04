# Performance e otimização

## Orçamentos orientadores

Estes valores são **metas** para código bem estruturado; medição real com `resmon` e **profiler** imperativo antes de otimizar à cega.

| Contexto | Meta orientadora |
|----------|-------------------|
| Client idle (contribuição do teu resource) | ≤ ~0.05 ms tempo médio por tick |
| Client em combate / zona ativa | ≤ ~0.30 ms sustentado |
| Server idle por resource | ≤ ~0.20 ms |
| Picos (loot batch, save em grupo) | ≤ ~1.5 ms — amortizar com filas / menos trabalho por jogador |

## Anti-padrões

| Problema | Porquê |
|----------|--------|
| `while true do ... end` sem `Wait` | Trava o scheduler do script |
| `GetGamePool('CPed')` / `CVehicle` a cada frame | Custo O(n) enorme |
| `TriggerClientEvent(-1, ...)` em hot path | Saturação de rede |
| Distância a todos os jogadores/NPCs todos os ticks | Usar zonas, grids ou maior intervalo |
| Vários `CreateThread` com loops sobrepostos para o mesmo sistema | Fundir numa máquina de estados |

## Bons padrões

1. **Um thread supervisor** por feature com estado e intervalos dinâmicos (`sleep` maior quando longe).
2. **ox_lib zones / PolyZone** — só corre código quando o jogador entra/sai ou está dentro com polling espaçado.
3. **State bags** (`Player(source).state:set(...)`) para flags que vários client scripts precisam ler sem spam de eventos.
4. **Cache** de `PlayerPedId()`, coords, e resultados de natives repetidos no mesmo tick.
5. **Batch server work**: processar filas em `SetTimeout` ou blocos com limite por tick.

## Ferramentas

| Ferramenta | Uso |
|------------|-----|
| **`resmon 1`** no cliente | Ver tempo por resource |
| **`profiler`** | `profiler record 600`, depois `profiler view` — identifica funções pesadas |
| **txAdmin** | Gráficos de perf quando disponível |

## NUI

- Não enviar `SendNUIMessage` a 60 Hz.
- Desativar atualizações quando o menu está fechado.
