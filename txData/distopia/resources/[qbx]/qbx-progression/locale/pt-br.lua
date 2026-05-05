local Translations = {
    error = {
        invalid_player = 'Jogador inválido.',
        invalid_amount = 'Quantidade de XP inválida.',
        invalid_reason = 'Motivo de XP inválido.',
        rate_limited = 'Ganho de XP bloqueado por limite de frequência.',
    },
    success = {
        xp_granted = 'Você ganhou %{amount} XP.',
        xp_granted_admin = 'Concedido %{amount} XP de personagem para %{target}.',
        level_up = 'Você alcancou o nivel de personagem %{level}.',
    },
    info = {
        progress = 'Nivel %{level} - %{xp}/%{xpToNext} XP - %{skillPoints} pontos de habilidade.',
    },
    command = {
        grant_xp = {
            help = 'Concede XP de personagem para um jogador.',
            player = 'ID do jogador',
            amount = 'Quantidade de XP',
            reason = 'Motivo do XP',
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
