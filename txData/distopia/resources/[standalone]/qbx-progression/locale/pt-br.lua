local Translations = {
    error = {
        invalid_player = 'Jogador invalido.',
        invalid_amount = 'Quantidade de XP invalida.',
        invalid_reason = 'Motivo de XP invalido.',
        rate_limited = 'Ganho de XP bloqueado por limite de frequencia.',
    },
    success = {
        xp_granted = 'Voce ganhou %{amount} XP.',
        xp_granted_admin = 'Concedido %{amount} XP de personagem para %{target}.',
        level_up = 'Voce alcancou o nivel de personagem %{level}.',
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
