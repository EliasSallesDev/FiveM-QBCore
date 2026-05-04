# Especificação: (Nome do sistema)

## 1. Objetivo e escopo

- **Objetivo:** 
- **Fora de escopo:** 

## 2. Dados persistidos

### 2.1 `PlayerData.metadata` (se aplicável)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| | | |

### 2.2 Tabelas SQL (se aplicável)

```sql
-- DDL idempotente (rascunho)
```

## 3. Eventos e exports

### 3.1 Eventos de rede (nomes finais em inglês)

| Direção | Nome | Payload | Notas |
|---------|------|---------|--------|
| C→S | | | |
| S→C | | | |

### 3.2 Exports

| Resource | Nome | Args | Retorno |
|----------|------|------|---------|
| `qbx-...` | | | |

## 4. Algoritmos chave

- Fórmulas, máquina de estados, pseudocódigo.

## 5. Configuração (`config.lua`)

- Grupos de opções e valores default.

## 6. Dependências

- **Resources:** `qb-core`, `ox_lib`, …
- **Outras specs:** ligações a [systems/00-overview.md](../systems/00-overview.md)

## 7. Riscos e anti-cheat

- Vetores de exploit e mitigação.

## 8. Plano de teste (manual)

1. 
2. 
3. 

## 9. Rollout e migração

- Ordem de `ensure`, SQL, feature flags.

## 10. Branding (se a feature tem UI)

- **Assets copiados para o resource:** quais ficheiros do pack `shared/Pack Logo Distopia/` (ex.: `logo-96.png`, `logo-512.png`, `loading.gif`).
- **Onde a logo aparece:** favicon, header, splash/loading, watermark.
- **Referência:** [branding.md](../branding.md).
