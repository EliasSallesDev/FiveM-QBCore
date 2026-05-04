# Testes e QA

## Realidade do FiveM

Não existe (na maioria dos projetos) uma suíte unitária completa para scripts Lua em runtime FiveM. O padrão é **plano de teste manual** documentado na spec de cada sistema ([templates/feature-spec-template.md](templates/feature-spec-template.md), secção “Plano de teste”).

## Ambiente

| Ambiente | Uso |
|----------|-----|
| **Dev / staging** | Testar migrations, restarts, regressões |
| **Produção** | Apenas após checklist e backup |

## Ferramentas

| Ferramenta | Uso |
|------------|-----|
| **FxDK** | Iteração rápida de scripts e mundo |
| **`refresh` / `restart <resource>`** | Validar ordem de start e dependências |
| **Conta de teste** | Personagem dedicado para não corromper dados reais |

## Comandos de debug

Cada feature deve expor comandos **admin/dev** protegidos por ACE (ex.: `qbadmin.allow`):

- `/dev_xp`, `/dev_zone`, `/dev_quest` — exemplos; nomes reais por resource.

Nunca deixar comandos de dar itens/XP **sem** permissão.

## Smoke test pré-deploy (sugestão)

1. Login e spawn sem erro.
2. `metadata` carregado (fome/sede visíveis no HUD se existir).
3. Save ao sair / restart resource do jogador.
4. Uma interação de cada sistema crítico alterado (ex.: entrar numa zona, completar um passo de quest).
5. Verificar consola do servidor por erros oxmysql.

## Regressão

Após mudar `qb-core` ou inventário, repetir smoke completo — são dependências centrais.
