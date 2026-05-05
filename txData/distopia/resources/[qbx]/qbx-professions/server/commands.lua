local QBCore = exports['qb-core']:GetCoreObject()

local function notifyOrPrint(source, message, messageType)
    if source > 0 then
        TriggerClientEvent('QBCore:Notify', source, message, messageType or 'primary')
    else
        print(('[qbx-professions] %s'):format(message))
    end
end

QBCore.Commands.Add('profession', Lang:t('command.profession.help'), {
    { name = Lang:t('command.profession.profession'), help = Lang:t('command.profession.profession') },
}, false, function(source, args)
    local professionId = args[1] or 'mining'
    local progress = Professions.GetProfessionProgress(source, professionId)

    if not progress then
        notifyOrPrint(source, Lang:t('error.invalid_profession'), 'error')
        return
    end

    notifyOrPrint(source, Lang:t('info.profession_status', {
        profession = progress.label,
        level = progress.level,
        xp = progress.xp,
        xpToNext = progress.xpToNext,
    }), 'primary')
end)

QBCore.Commands.Add('professions', Lang:t('command.professions.help'), {}, false, function(source)
    TriggerClientEvent('qbx-professions:client:openMenu', source)
end)

QBCore.Commands.Add('activateprofession', Lang:t('command.activate.help'), {
    { name = Lang:t('command.activate.profession'), help = Lang:t('command.activate.profession') },
}, true, function(source, args)
    local ok, result = Professions.ActivateProfession(source, args[1])

    if not ok then
        notifyOrPrint(source, Lang:t('error.' .. result), 'error')
        return
    end

    notifyOrPrint(source, Lang:t('success.profession_activated', {
        profession = args[1],
        active = #result.active,
        slots = result.unlockedSlots,
    }), 'success')
end)

QBCore.Commands.Add('deactivateprofession', Lang:t('command.deactivate.help'), {
    { name = Lang:t('command.deactivate.player'), help = Lang:t('command.deactivate.player') },
    { name = Lang:t('command.deactivate.profession'), help = Lang:t('command.deactivate.profession') },
}, true, function(source, args)
    local target = tonumber(args[1])
    local professionId = args[2]
    local ok, result = Professions.DeactivateProfession(target, professionId)

    if not ok then
        notifyOrPrint(source, Lang:t('error.' .. result), 'error')
        return
    end

    notifyOrPrint(source, Lang:t('success.profession_deactivated_admin', {
        target = target,
        profession = professionId,
        active = #result.active,
        slots = result.unlockedSlots,
    }), 'success')
end, 'admin')

QBCore.Commands.Add('setprofessionslots', Lang:t('command.set_slots.help'), {
    { name = Lang:t('command.set_slots.player'), help = Lang:t('command.set_slots.player') },
    { name = Lang:t('command.set_slots.amount'), help = Lang:t('command.set_slots.amount') },
}, true, function(source, args)
    local target = tonumber(args[1])
    local slots = tonumber(args[2])
    local ok, result = Professions.SetProfessionSlots(target, slots, 'admin')

    if not ok then
        notifyOrPrint(source, Lang:t('error.' .. result), 'error')
        return
    end

    notifyOrPrint(source, Lang:t('success.profession_slots_set_admin', {
        target = target,
        slots = result.unlockedSlots,
    }), 'success')
end, 'admin')

QBCore.Commands.Add('resetprofessions', Lang:t('command.reset.help'), {
    { name = Lang:t('command.reset.player'), help = Lang:t('command.reset.player') },
}, true, function(source, args)
    local target = tonumber(args[1])
    local ok = Professions.ResetPlayerProfessions(target)

    if not ok then
        notifyOrPrint(source, Lang:t('error.invalid_player'), 'error')
        return
    end

    notifyOrPrint(source, Lang:t('success.professions_reset_admin', {
        target = target,
    }), 'success')
end, 'admin')

QBCore.Commands.Add('grantprofessionxp', Lang:t('command.grant_xp.help'), {
    { name = Lang:t('command.grant_xp.player'), help = Lang:t('command.grant_xp.player') },
    { name = Lang:t('command.grant_xp.profession'), help = Lang:t('command.grant_xp.profession') },
    { name = Lang:t('command.grant_xp.amount'), help = Lang:t('command.grant_xp.amount') },
    { name = Lang:t('command.grant_xp.reason'), help = Lang:t('command.grant_xp.reason') },
}, true, function(source, args)
    local target = tonumber(args[1])
    local professionId = args[2]
    local amount = tonumber(args[3])
    local reason = args[4] or 'admin'

    local ok, result = Professions.AddProfessionXp(target, professionId, amount, reason)

    if not ok then
        notifyOrPrint(source, Lang:t('error.' .. result), 'error')
        return
    end

    notifyOrPrint(source, Lang:t('success.xp_granted_admin', {
        amount = amount,
        target = target,
        profession = result.label,
    }), 'success')
end, 'admin')

QBCore.Commands.Add('professiongather', Lang:t('command.gather.help'), {
    { name = Lang:t('command.gather.node'), help = Lang:t('command.gather.node') },
}, true, function(source, args)
    local ok, result, remaining = Professions.AttemptGather(source, args[1])

    if not ok then
        notifyOrPrint(source, Lang:t('error.' .. result, { seconds = remaining or 0 }), 'error')
        return
    end

    notifyOrPrint(source, Lang:t('success.gathered', {
        profession = result.label,
        amount = result.xp,
    }), 'success')
end, 'admin')

QBCore.Commands.Add('professioncraft', Lang:t('command.craft.help'), {
    { name = Lang:t('command.craft.recipe'), help = Lang:t('command.craft.recipe') },
}, true, function(source, args)
    local ok, result = Professions.AttemptCraft(source, args[1])

    if not ok then
        notifyOrPrint(source, Lang:t('error.' .. result), 'error')
        return
    end

    notifyOrPrint(source, Lang:t('success.crafted', {
        profession = result.label,
        amount = result.xp,
    }), 'success')
end, 'admin')
