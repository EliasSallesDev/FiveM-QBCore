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

local function sendAbilityStatus(menuData)
    local active = menuData and menuData.active or ClassesClient.classData

    sendHud('abilityStatus', {
        active = active,
        abilityStatus = active and active.abilityStatus or nil,
        hotkey = Config.AbilityHotkey and Config.AbilityHotkey.defaultKey or 'H',
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

        sendAbilityStatus(menuData)

        cb(menuData)
    end)
end

local function getActiveAbilityId()
    local activeClassId = ClassesClient.classData and ClassesClient.classData.id

    if not activeClassId then
        return nil
    end

    for abilityId, ability in pairs(Config.Abilities) do
        if ability.class == activeClassId then
            return abilityId
        end
    end

    return nil
end

local function useActiveAbility()
    local abilityId = getActiveAbilityId()

    if not abilityId then
        QBCore.Functions.Notify(Lang:t('error.invalid_ability'), 'error')
        return
    end

    QBCore.Functions.TriggerCallback('qbx-classes:server:tryUseAbility', function(ok, result, remaining)
        if ok then
            refreshClassHud()
            return
        end

        QBCore.Functions.Notify(Lang:t('error.' .. result, { seconds = remaining or 0 }), 'error')
        refreshClassHud()
    end, abilityId)
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
    sendAbilityStatus({ active = classData })
end)

RegisterNetEvent('qbx-classes:client:classUpdated', function(classData)
    ClassesClient.classData = classData
    ClassesClient.menuData = nil
    sendAbilityStatus({ active = classData })

    if ClassesClient.hudOpen then
        refreshClassHud()
    end
end)

RegisterNetEvent('qbx-classes:client:abilityUsed', function(ability, abilityStatus)
    ClassesClient.lastAbility = ability
    sendHud('abilityStatus', {
        active = ClassesClient.classData,
        abilityStatus = abilityStatus,
        hotkey = Config.AbilityHotkey and Config.AbilityHotkey.defaultKey or 'H',
    })

    if ability and ability.label then
        QBCore.Functions.Notify(Lang:t('success.ability_used', { ability = ability.label }), 'success')
    end
end)

RegisterNetEvent('qbx-classes:client:openMenu', openClassHud)
RegisterNetEvent('qbx-classes:client:openClassList', openClassHud)

RegisterCommand('classes', openClassHud)
RegisterCommand('chooseclass', openClassHud)
RegisterCommand(Config.AbilityHotkey.command, useActiveAbility)
RegisterKeyMapping(Config.AbilityHotkey.command, Config.AbilityHotkey.description, 'keyboard', Config.AbilityHotkey.defaultKey)

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
                sendAbilityStatus(menuData)
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
    refreshClassHud()
end)
