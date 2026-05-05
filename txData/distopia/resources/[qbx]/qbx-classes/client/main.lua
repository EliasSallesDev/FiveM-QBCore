local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports['qb-core']:GetCoreObject() end)

ClassesClient = ClassesClient or {
    classData = nil,
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
    ClassesClient.hudOpen = enabled
    SetNuiFocus(enabled, enabled)
end

local function requestMenuData(cb)
    QBCore.Functions.TriggerCallback('qbx-classes:server:getMenuData', function(menuData)
        ClassesClient.menuData = menuData

        if menuData and menuData.active then
            ClassesClient.classData = menuData.active
        end

        cb(menuData)
    end)
end

local function openClassHud()
    requestMenuData(function(menuData)
        if not menuData then
            QBCore.Functions.Notify(Lang:t('error.invalid_player'), 'error')
            return
        end

        focusHud(true)
        sendHud('open', {
            menuData = menuData,
            abilities = Config.Abilities,
        })
    end)
end

local function refreshClassHud()
    requestMenuData(function(menuData)
        sendHud('hydrate', {
            menuData = menuData,
            abilities = Config.Abilities,
        })
    end)
end

RegisterNetEvent('qbx-classes:client:classData', function(classData)
    ClassesClient.classData = classData
end)

RegisterNetEvent('qbx-classes:client:classUpdated', function(classData)
    ClassesClient.classData = classData
    ClassesClient.menuData = nil

    if ClassesClient.hudOpen then
        refreshClassHud()
    end
end)

RegisterNetEvent('qbx-classes:client:abilityUsed', function(ability)
    ClassesClient.lastAbility = ability

    if ability and ability.label then
        QBCore.Functions.Notify(Lang:t('success.ability_used', { ability = ability.label }), 'success')
    end
end)

RegisterNetEvent('qbx-classes:client:openMenu', openClassHud)
RegisterNetEvent('qbx-classes:client:openClassList', openClassHud)

RegisterCommand('classes', openClassHud)
RegisterCommand('chooseclass', openClassHud)

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
            abilities = Config.Abilities,
        })
    end)
end)

RegisterNUICallback('selectClass', function(data, cb)
    local classId = data and data.classId

    if not classId then
        cb({ ok = false, error = Lang:t('error.invalid_class') })
        return
    end

    QBCore.Functions.TriggerCallback('qbx-classes:server:changeClass', function(ok, result, remaining)
        if ok then
            requestMenuData(function(menuData)
                cb({
                    ok = true,
                    result = result,
                    menuData = menuData,
                    abilities = Config.Abilities,
                })
            end)
            return
        end

        cb({
            ok = false,
            error = Lang:t('error.' .. result, { seconds = remaining or 0 }),
        })
    end, classId)
end)

RegisterNUICallback('useAbility', function(data, cb)
    local abilityId = data and data.abilityId

    if not abilityId then
        cb({ ok = false, error = Lang:t('error.invalid_ability') })
        return
    end

    QBCore.Functions.TriggerCallback('qbx-classes:server:tryUseAbility', function(ok, result, remaining)
        if ok then
            requestMenuData(function(menuData)
                cb({
                    ok = true,
                    result = result,
                    menuData = menuData,
                    abilities = Config.Abilities,
                })
            end)
            return
        end

        cb({
            ok = false,
            error = Lang:t('error.' .. result, { seconds = remaining or 0 }),
        })
    end, abilityId)
end)

CreateThread(function()
    Wait(1000)
    TriggerServerEvent('qbx-classes:server:requestClass')
end)
