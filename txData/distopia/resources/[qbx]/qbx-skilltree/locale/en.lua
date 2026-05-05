local Translations = {
    error = {
        invalid_player = 'Invalid player.',
        invalid_node = 'Invalid skill node.',
        invalid_tree = 'Invalid skill tree.',
        class_required = 'This branch requires its matching active class.',
        prereq_required = 'Required node missing: %{detail}.',
        not_enough_points = 'Not enough skill points.',
        node_max_rank = 'This node is already at max rank.',
        db_error = 'Could not save skill node.',
        inventory_unavailable = 'Inventory is unavailable.',
        respec_item_required = 'You need a skill reset token.',
        no_nodes_allocated = 'You do not have allocated skill nodes.',
        action_in_progress = 'A skill tree action is already in progress.',
        internal_error = 'Skill tree action failed.',
    },
    success = {
        node_allocated = '%{node} rank %{rank} unlocked.',
        respec = 'Skill tree reset. Refunded %{points} point(s), tax %{tax}.',
        admin_respec = 'Reset skill tree for %{target}; refunded %{points} point(s).',
    },
    command = {
        open = {
            help = 'Open the Distopia skill tree.',
        },
        admin_reset = {
            help = 'Reset a player skill tree without consuming an item.',
            player = 'Player ID',
        },
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true,
})
