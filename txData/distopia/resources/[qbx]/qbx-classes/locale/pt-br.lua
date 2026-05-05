local Translations = {
    error = {
        class_not_chosen = 'Escolha uma classe primeiro.',
        invalid_player = 'Jogador inválido.',
        invalid_class = 'Classe inválida.',
        same_class = 'Você ja possui esta classe.',
        class_change_cooldown = 'A troca de classe esta em cooldown por %{seconds} segundos.',
        class_change_in_combat = 'Você nao pode trocar de classe em combate.',
        insufficient_cost = 'Você precisa de um Token de Troca de Classe. O item sera consumido na troca.',
        inventory_unavailable = 'O inventario de troca de classe esta indisponivel.',
        invalid_amount = 'Quantidade de XP de classe inválida.',
        invalid_reason = 'Motivo de XP de classe inválido.',
        rate_limited = 'Ganho de XP de classe bloqueado por limite de frequência.',
        invalid_ability = 'Habilidade de classe inválida.',
        ability_wrong_class = 'Sua classe nao pode usar esta habilidade.',
        ability_level_required = 'Seu nivel de classe e baixo demais para esta habilidade.',
        ability_cooldown = 'Habilidade em cooldown por %{seconds} segundos.',
        ability_resource_unavailable = 'Você nao possui recurso suficiente para esta habilidade.',
        ability_resource_failed = 'A validação de recurso da habilidade falhou.',
    },
    success = {
        class_changed = 'Classe alterada para %{class}.',
        class_changed_admin = 'Classe de %{target} alterada para %{class}.',
        xp_granted = 'Você ganhou %{amount} XP de classe.',
        xp_granted_admin = 'Concedido %{amount} XP de %{class} para %{target}.',
        class_level_up = '%{class} alcançou o nível %{level}.',
        ability_used = '%{ability} usada.',
    },
    info = {
        class_status = '%{class} nível %{level} - %{xp}/%{xpToNext} XP.',
    },
    command = {
        class = {
            help = 'Mostra sua classe atual.',
        },
        set_class = {
            help = 'Define a classe de um jogador.',
            player = 'ID do jogador',
            class = 'ID da classe',
        },
        grant_xp = {
            help = 'Concede XP de classe para um jogador.',
            player = 'ID do jogador',
            amount = 'Quantidade de XP',
            reason = 'Motivo do XP',
        },
        ability = {
            help = 'Usa uma habilidade de classe.',
            ability = 'ID da habilidade',
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
