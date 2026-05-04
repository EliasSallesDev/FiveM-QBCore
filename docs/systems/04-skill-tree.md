# Sistema: Árvore de habilidades (passivas e ativas)

## 1. Objetivo e escopo

- **Objetivo:** Gastar **skill points** (do personagem) em **nós** por classe (ou árvore neutra). Nós podem ser **passivos** (mods permanentes) ou **ativos** (desbloqueiam rank de habilidade já definida na classe).
- **Fora de escopo:** Implementação visual da UI — apenas contrato de dados e API.

## 2. Dados persistidos

### Tabela principal (recomendado)

```sql
CREATE TABLE IF NOT EXISTS qbx_skill_nodes (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  citizenid VARCHAR(50) NOT NULL,
  tree_id VARCHAR(32) NOT NULL,
  node_id VARCHAR(64) NOT NULL,
  rank SMALLINT NOT NULL DEFAULT 1,
  allocated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_player_node (citizenid, tree_id, node_id),
  KEY idx_citizenid (citizenid)
);
```

`tree_id` pode ser `class.warrior`, `profession.mining`, ou `seasonal.*`.

### Metadata espelho (opcional)

`PlayerData.metadata.skillPoints` deve espelhar o valor em [01-personagem-e-progressao.md](01-personagem-e-progressao.md) — **fonte da verdade** para pontos disponíveis continua a ser o sistema de progressão.

## 3. Regras

- **Pré-requisitos:** grafo dirigido `requires = { 'node_a:rank2', ... }` em `config.lua`.
- **Custo crescente:** `costPerRank[r]` em config.
- **Respec:** item raro `skill_reset_token` → servidor limpa linhas da tabela e devolve pontos gastos com taxa `Config.RespecTax`.

## 4. Eventos e exports

| Export | Descrição |
|--------|-----------|
| `TryAllocateNode(src, treeId, nodeId)` | Valida prereqs + pontos |
| `GetAllocatedNodes(citizenid)` | Para UI |

## 5. UI (NUI)

- Abrir com comando/target; enviar grafo estático (JSON) + estado alocado do servidor.

## 6. Dependências

- Progressão ([01](01-personagem-e-progressao.md)), Classes ([02](02-classes.md))

## 7. Riscos

- **Nunca** confiar em payload do client para “comprar” nó sem revalidar prereqs no servidor.

## 8. Plano de teste

1. Alocar nó válido — pontos diminuem.
2. Prereq inválido falha.
3. Respec devolve pontos corretos.
