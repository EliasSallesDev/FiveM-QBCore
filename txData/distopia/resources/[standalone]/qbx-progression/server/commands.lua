local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add('grantcharxp', Lang:t('command.grant_xp.help'), {
    { name = Lang:t('command.grant_xp.player'), help = Lang:t('command.grant_xp.player') },
    { name = Lang:t('command.grant_xp.amount'), help = Lang:t('command.grant_xp.amount') },
    { name = Lang:t('command.grant_xp.reason'), help = Lang:t('command.grant_xp.reason') },
}, true, function(source, args)
    local target = tonumber(args[1])
    local amount = tonumber(args[2])
    local reason = args[3] or 'admin'

    local ok, result = Progression.GrantCharacterXp(target, amount, reason)

    if not ok then
        if source > 0 then
            TriggerClientEvent('QBCore:Notify', source, Lang:t('error.' .. result), 'error')
        else
            print(('[qbx-progression] grantcharxp failed: %s'):format(tostring(result)))
        end

        return
    end

    local message = Lang:t('success.xp_granted_admin', {
        amount = amount,
        target = target,
    })

    if source > 0 then
        TriggerClientEvent('QBCore:Notify', source, message, 'success')
    else
        print(('[qbx-progression] %s'):format(message))
    end
end, 'admin')
