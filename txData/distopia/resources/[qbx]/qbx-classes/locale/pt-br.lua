local Translations = {
    error = {
        invalid_player = 'Jogador invalido.',
        invalid_class = 'Classe invalida.',
        same_class = 'Voce ja possui esta classe.',
        class_change_cooldown = 'A troca de classe esta em cooldown por %{seconds} segundos.',
        class_change_in_combat = 'Voce nao pode trocar de classe em combate.',
        insufficient_cost = 'Voce precisa de um Token de Troca de Classe. O item sera consumido na troca.',
        inventory_unavailable = 'O inventario de troca de classe esta indisponivel.',
        invalid_amount = 'Quantidade de XP de classe invalida.',
        invalid_reason = 'Motivo de XP de classe invalido.',
        rate_limited = 'Ganho de XP de classe bloqueado por limite de frequencia.',
        invalid_ability = 'Habilidade de classe invalida.',
        ability_wrong_class = 'Sua classe nao pode usar esta habilidade.',
        ability_level_required = 'Seu nivel de classe e baixo demais para esta habilidade.',
        ability_cooldown = 'Habilidade em cooldown por %{seconds} segundos.',
        ability_resource_unavailable = 'Voce nao possui recurso suficiente para esta habilidade.',
        ability_resource_failed = 'A validacao de recurso da habilidade falhou.',
    },
    success = {
        class_changed = 'Classe alterada para %{class}.',
        class_changed_admin = 'Classe de %{target} alterada para %{class}.',
        xp_granted = 'Voce ganhou %{amount} XP de classe.',
        xp_granted_admin = 'Concedido %{amount} XP de %{class} para %{target}.',
        class_level_up = '%{class} alcancou o nivel %{level}.',
        ability_used = '%{ability} usada.',
    },
    info = {
        class_status = '%{class} nivel %{level} - %{xp}/%{xpToNext} XP.',
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
