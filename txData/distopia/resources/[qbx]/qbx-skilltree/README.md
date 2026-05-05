# qbx-skilltree

Arvore de habilidades da Distopia para QBCore. O recurso persiste nos alocados em `qbx_skill_nodes` e consome `PlayerData.metadata.character.skillPoints` como fonte de pontos disponiveis.

## Comandos

- `/skilltree` abre a NUI.
- `/resetskilltree [id]` reseta um jogador sem consumir item, restrito a permissao `admin`.

## Exports

- `TryAllocateNode(src, treeId, nodeId)` valida classe, prerequisitos, rank e pontos antes de gravar.
- `GetAllocatedNodes(citizenid)` retorna linhas persistidas para UI ou outros recursos.
- `GetMenuData(src)` retorna arvores, pontos, classe ativa e estado alocado.
- `GetSkillModifiers(src)` soma passivas aplicaveis para a arvore neutra e a classe ativa.
- `GetAbilityRanks(src)` retorna ranks de habilidades ativas desbloqueadas pela classe ativa.
- `RespecPlayer(src, consumeItem)` limpa nos e devolve pontos com taxa.

## Persistencia

Execute `sql/0001_skill_nodes.sql` no banco com `oxmysql` antes de garantir o recurso em producao.

## Integracao

Quando `qbx-skilltree` esta iniciado, `qbx-classes` consome os exports de modifiers e ranks ativos. Passivas aplicaveis somam aos multiplicadores da classe ativa, e ranks ativos aumentam duracao e reduzem cooldown da habilidade correspondente.

## Seguranca

Alocacao e respec usam lock por jogador para evitar chamadas simultaneas. O servidor continua revalidando custo, prerequisitos, classe ativa e pontos antes de persistir qualquer mudanca.
