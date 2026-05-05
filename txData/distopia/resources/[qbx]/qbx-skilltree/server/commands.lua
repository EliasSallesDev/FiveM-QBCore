local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add(Config.Commands.open, Lang:t('command.open.help'), {}, false, function(source)
    TriggerClientEvent('qbx-skilltree:client:openMenu', source)
end)

QBCore.Commands.Add(Config.Commands.adminReset, Lang:t('command.admin_reset.help'), {
    {
        name = 'id',
        help = Lang:t('command.admin_reset.player'),
    },
}, true, function(source, args)
    local target = tonumber(args[1])

    if not target then
        TriggerClientEvent('QBCore:Notify', source, Lang:t('error.invalid_player'), 'error')
        return
    end

    local ok, result = SkillTree.RespecPlayer(target, false)

    if not ok then
        TriggerClientEvent('QBCore:Notify', source, Lang:t('error.' .. result), 'error')
        return
    end

    TriggerClientEvent('QBCore:Notify', source, Lang:t('success.admin_respec', {
        target = target,
        points = result.respec.refund,
    }), 'success')
end, 'admin')
