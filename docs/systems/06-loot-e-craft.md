# Sistema: Loot e craft

## 1. Objetivo e escopo

- **Objetivo:** **Loot tables** ponderadas por raridade e tier de fonte (NPC/bioma/zona); **craft** com bancadas; **salvaging** de itens em materiais.
- **Fora de escopo:** Lista completa de itens (`qb-core/shared/items.lua` ou ox_inventory).

## 2. Raridade

| Tier | Cor sugerida | Peso base |
|------|----------------|-----------|
| common | cinza | 100 |
| uncommon | verde | 40 |
| rare | azul | 15 |
| epic | roxo | 5 |
| legendary | laranja | 1 |

## 3. Loot table (config)

```lua
Config.LootPools = {
  npc_bandit_yellow = {
    rolls = 2,
    entries = {
      { item = 'bandage', min = 1, max = 2, weight = 60, rarity = 'common' },
      { item = 'pistol_ammo', min = 1, max = 5, weight = 30, rarity = 'uncommon' },
    }
  }
}
```

**Roll servidor:** para cada roll, somar pesos, `random`, deduzir inventory weight antes de aceitar.

## 4. Craft

- **Bench físico** com target + UI NUI ou ox_lib menu.
- Servidor valida: profissão + nível ([03-profissoes.md](03-profissoes.md)), presença de materiais, zona se necessário.

## 5. Salvaging

- Item configurável `salvage_into = { steel_scrap = {1,3} }`.
- Servidor remove item e adiciona materiais — nunca client.

## 6. SQL opcional (analytics)

```sql
CREATE TABLE IF NOT EXISTS qbx_loot_audit (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  citizenid VARCHAR(50) NOT NULL,
  pool_id VARCHAR(64) NOT NULL,
  drops JSON NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 7. Dependências

- Inventário
- Profissões
- Zonas/NPC tier ([09](09-zonas-e-npc-hostis.md))

## 8. Riscos

- Duping via disconnect durante craft — usar transação ou estado `pending_craft` na sessão servidor.

## 9. Plano de teste

1. Roll de loot 100x estatístico (script admin off-line).
2. Craft sem materiais falha.
3. Salvage correto.
