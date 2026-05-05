local Translations = {
    error = {
        invalid_player = 'Jogador inválido.',
        invalid_profession = 'Profissão inválida.',
        invalid_amount = 'Quantidade de XP de profissão inválida.',
        invalid_reason = 'Motivo de XP de profissão inválido.',
        rate_limited = 'Ganho de XP de profissão bloqueado por limite de frequência.',
        invalid_gather_node = 'Ponto de coleta inválido.',
        invalid_recipe = 'Receita inválida.',   
        invalid_station = 'Bancada de craft inválida.',
        profession_inactive = 'Esta profissão nao esta ativa no seu personagem.',
        profession_already_active = 'Esta profissão ja esta ativa.',
        profession_slot_required = 'Você precisa de um slot de profissão disponivel.',
        profession_slot_item_required = 'Você precisa de uma Licença de Profissão.',
        max_profession_slots = 'Você ja desbloqueou o maximo de profissões ativas.',
        invalid_slot_amount = 'Quantidade de slots de profissão inválida.',
        profession_not_active = 'Esta profissão nao esta ativa.',
        last_profession_active = 'Você nao pode desativar a ultima profissão ativa.',
        inventory_unavailable = 'Inventário indisponível.',
        inventory_add_failed = 'Nao foi possivel adicionar o item coletado ou craftado.',
        missing_tool = 'Você nao possui a ferramenta necessaria.',
        missing_ingredients = 'Você nao possui os ingredientes necessarios.',
        level_required = 'Seu nível de profissão e baixo demais.',
        too_far = 'Você esta longe demais do ponto de profissão.',
        node_cooldown = 'Este recurso está recuperando por %{seconds} segundos.',
    },
    success = {
        xp_granted = 'Você ganhou %{amount} XP de %{profession}.',
        xp_granted_admin = 'Concedido %{amount} XP de %{profession} para %{target}.',
        level_up = '%{profession} alcançou o nível %{level}.',
        gathered = 'Materiais coletados. Você ganhou %{amount} XP de %{profession}.',
        crafted = 'Item craftado. Você ganhou %{amount} XP de %{profession}.',
        profession_activated = '%{profession} agora está ativa. %{active}/%{slots} slots ativos usados.',
        profession_deactivated_admin = '%{profession} desativada para %{target}. %{active}/%{slots} slots ativos usados.',
        profession_slot_unlocked = 'Slot de profissão desbloqueado. Você agora possui %{slots} slots ativos.',
        profession_slots_set_admin = 'Slots de profissão de %{target} definidos para %{slots}.',   
        professions_reset_admin = 'Profissões de %{target} resetadas.',
    },
    info = {
        profession_status = '%{profession} nível %{level} - %{xp}/%{xpToNext} XP.',
    },
    command = {
        profession = {
            help = 'Mostra seu progresso de profissão.',
            profession = 'ID da profissão',
        },
        professions = {
            help = 'Abre a HUD de seleção de profissões.',
        },
        activate = {
            help = 'Ativa uma profissão se houver slot livre.',
            profession = 'ID da profissão',
        },
        deactivate = {
            help = 'Desativa uma profissão ativa de um jogador.',
            player = 'ID do jogador',
            profession = 'ID da profissão',
        },
        set_slots = {
            help = 'Define slots de profissão ativa para um jogador.',
            player = 'ID do jogador',
            amount = 'Quantidade de slots',
        },
        reset = {
            help = 'Reseta progresso e slots de profissão de um jogador.',
            player = 'ID do jogador',
        },
        grant_xp = {
            help = 'Concede XP de profissão para um jogador.',
            player = 'ID do jogador',
            profession = 'ID da profissão',
            amount = 'Quantidade de XP',
            reason = 'Motivo do XP',
        },
        gather = {
            help = 'Smoke-test admin de um ponto de coleta de profissão.',
            node = 'ID do ponto de coleta',
        },
        craft = {
            help = 'Smoke-test admin de uma receita de profissão.',
            recipe = 'ID da receita',
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
