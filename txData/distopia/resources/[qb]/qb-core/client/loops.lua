CreateThread(function()
    while true do
        local sleep = 1000
        if LocalPlayer.state.isLoggedIn then
            sleep = (1000 * 60) * QBCore.Config.UpdateInterval
            TriggerServerEvent('QBCore:UpdatePlayer')
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local PlayerData = QBCore.Functions.GetPlayerData()
            local metadata = PlayerData.metadata or {}

            local hunger = metadata['hunger'] or 100
            local thirst = metadata['thirst'] or 100
            local isdead = metadata['isdead'] or false
            local inlaststand = metadata['inlaststand'] or false

            if (hunger <= 0 or thirst <= 0) and not (isdead or inlaststand) then
                local ped = PlayerPedId()
                local currentHealth = GetEntityHealth(ped)
                local decreaseThreshold = math.random(5, 10)

                SetEntityHealth(ped, currentHealth - decreaseThreshold)
            end
        end

        Wait(QBCore.Config.StatusInterval)
    end
end)