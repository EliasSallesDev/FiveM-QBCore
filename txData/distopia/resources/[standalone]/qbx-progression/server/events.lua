AddEventHandler('qbx-progression:server:grantXp', function(src, amount, reason)
    src = tonumber(src)

    if not src or src <= 0 then
        return
    end

    local ok, err = Progression.GrantCharacterXp(src, amount, reason)

    if not ok then
        print(('[qbx-progression] rejected grantXp source=%s reason=%s error=%s'):format(src, tostring(reason), tostring(err)))
    end
end)

RegisterNetEvent('qbx-progression:server:requestProgress', function()
    local src = source
    local progress = Progression.GetCharacterProgress(src)

    if progress then
        TriggerClientEvent('qbx-progression:client:progress', src, progress)
    end
end)
