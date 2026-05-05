local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports['qb-core']:GetCoreObject() end)

ProfessionsClient = ProfessionsClient or {
    menuData = nil,
    hudOpen = false,
}

local function sendHud(action, payload)
    SendNUIMessage({
        action = action,
        payload = payload or {},
    })
end

local function focusHud(enabled)
    ProfessionsClient.hudOpen = enabled
    SetNuiFocus(enabled, enabled)
end

local function requestMenuData(cb)
    QBCore.Functions.TriggerCallback('qbx-professions:server:getMenuData', function(menuData)
        ProfessionsClient.menuData = menuData
        cb(menuData)
    end)
end

local function refreshProfessionHud()
    requestMenuData(function(menuData)
        sendHud('hydrate', {
            menuData = menuData,
        })
    end)
end

local function openProfessionHud()
    requestMenuData(function(menuData)
        if not menuData then
            QBCore.Functions.Notify(Lang:t('error.invalid_player'), 'error')
            return
        end

        focusHud(true)
        sendHud('open', {
            menuData = menuData,
        })
    end)
end

RegisterNetEvent('qbx-professions:client:professionUpdated', function(_profession, _amount, _reason)
    if ProfessionsClient.hudOpen then
        refreshProfessionHud()
    end
end)

RegisterNetEvent('qbx-professions:client:professionStateUpdated', function(menuData)
    ProfessionsClient.menuData = menuData

    if ProfessionsClient.hudOpen then
        sendHud('hydrate', { menuData = menuData })
    end
end)

RegisterNetEvent('qbx-professions:client:openMenu', openProfessionHud)

RegisterCommand('professions', openProfessionHud)
RegisterCommand('chooseprofession', openProfessionHud)

RegisterNUICallback('close', function(_, cb)
    focusHud(false)
    sendHud('close')
    cb({ ok = true })
end)

RegisterNUICallback('refresh', function(_, cb)
    requestMenuData(function(menuData)
        cb({
            ok = menuData ~= nil,
            menuData = menuData,
        })
    end)
end)

RegisterNUICallback('activateProfession', function(data, cb)
    local professionId = data and data.professionId

    if not professionId then
        cb({ ok = false, error = Lang:t('error.invalid_profession') })
        return
    end

    QBCore.Functions.TriggerCallback('qbx-professions:server:activateProfession', function(ok, result)
        if ok then
            cb({
                ok = true,
                menuData = result,
            })
            return
        end

        cb({
            ok = false,
            error = Lang:t('error.' .. result),
        })
    end, professionId)
end)

CreateThread(function()
    Wait(1000)
    refreshProfessionHud()
end)
