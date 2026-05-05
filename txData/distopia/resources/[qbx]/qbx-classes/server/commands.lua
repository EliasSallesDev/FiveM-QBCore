local QBCore = exports['qb-core']:GetCoreObject()

local function notifyOrPrint(source, message, messageType)
    if source > 0 then
        TriggerClientEvent('QBCore:Notify', source, message, messageType or 'primary')
    else
        print(('[qbx-classes] %s'):format(message))
    end
end

QBCore.Commands.Add('class', Lang:t('command.class.help'), {}, false, function(source)
    local classData = Classes.GetPlayerClass(source)

    if not classData then
        notifyOrPrint(source, Lang:t('error.class_not_chosen'), 'error')
        return
    end

    notifyOrPrint(source, Lang:t('info.class_status', {
        class = classData.label,
        level = classData.level,
        xp = classData.xp,
        xpToNext = classData.xpToNext,
    }), 'primary')
end)

QBCore.Commands.Add('setclass', Lang:t('command.set_class.help'), {
    { name = Lang:t('command.set_class.player'), help = Lang:t('command.set_class.player') },
    { name = Lang:t('command.set_class.class'), help = Lang:t('command.set_class.class') },
}, true, function(source, args)
    local target = tonumber(args[1])
    local classId = args[2]

    local ok, result = Classes.SetPlayerClass(target, classId, true)

    if not ok then
        notifyOrPrint(source, Lang:t('error.' .. result), 'error')
        return
    end

    notifyOrPrint(source, Lang:t('success.class_changed_admin', {
        target = target,
        class = result.label,
    }), 'success')
end, 'admin')

QBCore.Commands.Add('grantclassxp', Lang:t('command.grant_xp.help'), {
    { name = Lang:t('command.grant_xp.player'), help = Lang:t('command.grant_xp.player') },
    { name = Lang:t('command.grant_xp.amount'), help = Lang:t('command.grant_xp.amount') },
    { name = Lang:t('command.grant_xp.reason'), help = Lang:t('command.grant_xp.reason') },
}, true, function(source, args)
    local target = tonumber(args[1])
    local amount = tonumber(args[2])
    local reason = args[3] or 'admin'

    local ok, result = Classes.GrantClassXp(target, amount, reason)

    if not ok then
        notifyOrPrint(source, Lang:t('error.' .. result), 'error')
        return
    end

    notifyOrPrint(source, Lang:t('success.xp_granted_admin', {
        amount = amount,
        target = target,
        class = result.label,
    }), 'success')
end, 'admin')

QBCore.Commands.Add('classability', Lang:t('command.ability.help'), {
    { name = Lang:t('command.ability.ability'), help = Lang:t('command.ability.ability') },
}, true, function(source, args)
    local abilityId = args[1]
    local ok, result, remaining = Classes.TryUseAbility(source, abilityId)

    if not ok then
        notifyOrPrint(source, Lang:t('error.' .. result, { seconds = remaining or 0 }), 'error')
        return
    end

    notifyOrPrint(source, Lang:t('success.ability_used', { ability = result.label }), 'success')
end)
