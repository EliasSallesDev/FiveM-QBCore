local Translations = {
    error = {
        invalid_player = 'Jogador invalido.',
        invalid_node = 'No de habilidade invalido.',
        invalid_tree = 'Arvore de habilidade invalida.',
        class_required = 'Este ramo exige a classe ativa correspondente.',
        prereq_required = 'Pre-requisito ausente: %{detail}.',
        not_enough_points = 'Pontos de habilidade insuficientes.',
        node_max_rank = 'Este no ja esta no rank maximo.',
        db_error = 'Nao foi possivel salvar o no de habilidade.',
        inventory_unavailable = 'Inventario indisponivel.',
        respec_item_required = 'Voce precisa de um token de reset de habilidades.',
        no_nodes_allocated = 'Voce nao possui nos de habilidade alocados.',
        action_in_progress = 'Uma acao da arvore de habilidades ja esta em andamento.',
        internal_error = 'A acao da arvore de habilidades falhou.',
    },
    success = {
        node_allocated = '%{node} rank %{rank} desbloqueado.',
        respec = 'Arvore resetada. %{points} ponto(s) devolvido(s), taxa %{tax}.',
        admin_respec = 'Arvore de %{target} resetada; %{points} ponto(s) devolvido(s).',
    },
    command = {
        open = {
            help = 'Abre a arvore de habilidades de Distopia.',
        },
        admin_reset = {
            help = 'Reseta a arvore de um jogador sem consumir item.',
            player = 'ID do jogador',
        },
    },
}

if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
