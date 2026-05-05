AddEventHandler('qbx-classes:server:setClass', function(src, classId, force)
    src = tonumber(src)

    if not src or src <= 0 then
        return
    end

    local ok, err = Classes.SetPlayerClass(src, classId, force == true)

    if not ok then
        print(('[qbx-classes] rejected setClass source=%s class=%s error=%s'):format(src, tostring(classId), tostring(err)))
    end
end)

AddEventHandler('qbx-classes:server:grantXp', function(src, amount, reason)
    src = tonumber(src)

    if not src or src <= 0 then
        return
    end

    local ok, err = Classes.GrantClassXp(src, amount, reason)

    if not ok then
        print(('[qbx-classes] rejected grantXp source=%s reason=%s error=%s'):format(src, tostring(reason), tostring(err)))
    end
end)

RegisterNetEvent('qbx-classes:server:requestClass', function()
    local src = source
    local classData = Classes.GetPlayerClass(src)

    if classData then
        TriggerClientEvent('qbx-classes:client:classData', src, classData)
    end
end)

RegisterNetEvent('qbx-classes:server:requestClassChange', function(classId)
    local src = source
    local ok, err, remaining = Classes.SetPlayerClass(src, classId, false)

    if not ok then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.' .. err, { seconds = remaining or 0 }), 'error')
    end
end)

RegisterNetEvent('qbx-classes:server:tryUseAbility', function(abilityId)
    local src = source
    local ok, err, remaining = Classes.TryUseAbility(src, abilityId)

    if not ok then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.' .. err, { seconds = remaining or 0 }), 'error')
    end
end)
