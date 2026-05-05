RegisterNetEvent('qbx-professions:server:gather', function(nodeId)
    local src = source
    local ok, result, remaining = Professions.AttemptGather(src, nodeId)

    if not ok then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.' .. result, { seconds = remaining or 0 }), 'error')
    end
end)

RegisterNetEvent('qbx-professions:server:craft', function(recipeId)
    local src = source
    local ok, result = Professions.AttemptCraft(src, recipeId)

    if not ok then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.' .. result), 'error')
    end
end)
