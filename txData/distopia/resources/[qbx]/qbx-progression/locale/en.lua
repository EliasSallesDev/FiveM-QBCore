local Translations = {
    error = {
        invalid_player = 'Invalid player.',
        invalid_amount = 'Invalid XP amount.',
        invalid_reason = 'Invalid XP reason.',
        rate_limited = 'XP grant rejected by rate limit.',
    },
    success = {
        xp_granted = 'You gained %{amount} XP.',
        xp_granted_admin = 'Granted %{amount} character XP to %{target}.',
        level_up = 'You reached character level %{level}.',
    },
    info = {
        progress = 'Level %{level} - %{xp}/%{xpToNext} XP - %{skillPoints} skill points.',
    },
    command = {
        grant_xp = {
            help = 'Grant character XP to a player.',
            player = 'Player ID',
            amount = 'XP amount',
            reason = 'XP reason',
        },
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true,
})
