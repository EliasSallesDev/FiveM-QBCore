local Translations = {
    error = {
        invalid_player = 'Invalid player.',
        invalid_profession = 'Invalid profession.',
        invalid_amount = 'Invalid profession XP amount.',
        invalid_reason = 'Invalid profession XP reason.',
        rate_limited = 'Profession XP gain was rate limited.',
        invalid_gather_node = 'Invalid gather node.',
        invalid_recipe = 'Invalid recipe.',
        invalid_station = 'Invalid crafting station.',
        profession_inactive = 'This profession is not active for your character.',
        profession_already_active = 'This profession is already active.',
        profession_slot_required = 'You need an available profession slot.',
        profession_slot_item_required = 'You need a Profession License.',
        max_profession_slots = 'You already unlocked the maximum number of active professions.',
        invalid_slot_amount = 'Invalid profession slot amount.',
        profession_not_active = 'This profession is not active.',
        last_profession_active = 'You cannot deactivate the last active profession.',
        inventory_unavailable = 'Inventory is unavailable.',
        inventory_add_failed = 'Could not add the crafted or gathered item.',
        missing_tool = 'You do not have the required tool.',
        missing_ingredients = 'You do not have the required ingredients.',
        level_required = 'Your profession level is too low.',
        too_far = 'You are too far from the profession spot.',
        node_cooldown = 'This resource is recovering for %{seconds} seconds.',
    },
    success = {
        xp_granted = 'You gained %{amount} %{profession} XP.',
        xp_granted_admin = 'Granted %{amount} %{profession} XP to %{target}.',
        level_up = '%{profession} reached level %{level}.',
        gathered = 'Gathered materials and gained %{amount} %{profession} XP.',
        crafted = 'Crafted item and gained %{amount} %{profession} XP.',
        profession_activated = '%{profession} is now active. %{active}/%{slots} active slots used.',
        profession_deactivated_admin = 'Deactivated %{profession} for %{target}. %{active}/%{slots} active slots used.',
        profession_slot_unlocked = 'Profession slot unlocked. You now have %{slots} active slots.',
        profession_slots_set_admin = 'Set profession slots for %{target} to %{slots}.',
        professions_reset_admin = 'Reset professions for %{target}.',
    },
    info = {
        profession_status = '%{profession} level %{level} - %{xp}/%{xpToNext} XP.',
    },
    command = {
        profession = {
            help = 'Shows your profession progress.',
            profession = 'Profession ID',
        },
        professions = {
            help = 'Opens the profession selection HUD.',
        },
        activate = {
            help = 'Activates a profession if you have a free slot.',
            profession = 'Profession ID',
        },
        deactivate = {
            help = 'Deactivates one active profession for a player.',
            player = 'Player ID',
            profession = 'Profession ID',
        },
        set_slots = {
            help = 'Sets active profession slots for a player.',
            player = 'Player ID',
            amount = 'Slot amount',
        },
        reset = {
            help = 'Resets a player profession progress and active slots.',
            player = 'Player ID',
        },
        grant_xp = {
            help = 'Grants profession XP to a player.',
            player = 'Player ID',
            profession = 'Profession ID',
            amount = 'XP amount',
            reason = 'XP reason',
        },
        gather = {
            help = 'Admin smoke-test for a profession gather node.',
            node = 'Gather node ID',
        },
        craft = {
            help = 'Admin smoke-test for a profession recipe.',
            recipe = 'Recipe ID',
        },
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true,
})
