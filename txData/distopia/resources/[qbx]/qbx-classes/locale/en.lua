local Translations = {
    error = {
        invalid_player = 'Invalid player.',
        invalid_class = 'Invalid class.',
        same_class = 'You already have this class.',
        class_change_cooldown = 'Class change is on cooldown for %{seconds} seconds.',
        class_change_in_combat = 'You cannot change class while in combat.',
        insufficient_cost = 'You do not have the required class change item.',
        inventory_unavailable = 'Class change inventory is unavailable.',
        invalid_amount = 'Invalid class XP amount.',
        invalid_reason = 'Invalid class XP reason.',
        rate_limited = 'Class XP grant rejected by rate limit.',
        invalid_ability = 'Invalid class ability.',
        ability_wrong_class = 'Your class cannot use this ability.',
        ability_level_required = 'Your class level is too low for this ability.',
        ability_cooldown = 'Ability is on cooldown for %{seconds} seconds.',
        ability_resource_unavailable = 'You do not have enough resources for this ability.',
        ability_resource_failed = 'Ability resource validation failed.',
    },
    success = {
        class_changed = 'Class changed to %{class}.',
        class_changed_admin = 'Changed class for %{target} to %{class}.',
        xp_granted = 'You gained %{amount} class XP.',
        xp_granted_admin = 'Granted %{amount} %{class} XP to %{target}.',
        class_level_up = '%{class} reached level %{level}.',
        ability_used = 'Used %{ability}.',
    },
    info = {
        class_status = '%{class} level %{level} - %{xp}/%{xpToNext} XP.',
    },
    command = {
        class = {
            help = 'Show your current class.',
        },
        set_class = {
            help = 'Set a player class.',
            player = 'Player ID',
            class = 'Class ID',
        },
        grant_xp = {
            help = 'Grant class XP to a player.',
            player = 'Player ID',
            amount = 'XP amount',
            reason = 'XP reason',
        },
        ability = {
            help = 'Use a class ability.',
            ability = 'Ability ID',
        },
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true,
})
