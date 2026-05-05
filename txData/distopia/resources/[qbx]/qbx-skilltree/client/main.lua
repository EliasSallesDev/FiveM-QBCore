local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports['qb-core']:GetCoreObject() end)

SkillTreeClient = SkillTreeClient or {
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
    SkillTreeClient.hudOpen = enabled
    SetNuiFocus(enabled, enabled)
end

local function requestMenuData(cb)
    QBCore.Functions.TriggerCallback('qbx-skilltree:server:getMenuData', function(menuData)
        SkillTreeClient.menuData = menuData
        cb(menuData)
    end)
end

local function refreshSkillTreeHud()
    requestMenuData(function(menuData)
        sendHud('hydrate', {
            menuData = menuData,
        })
    end)
end

local function openSkillTreeHud()
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

RegisterNetEvent('qbx-skilltree:client:skillTreeUpdated', function(menuData)
    SkillTreeClient.menuData = menuData

    if SkillTreeClient.hudOpen then
        sendHud('hydrate', { menuData = menuData })
    end
end)

RegisterNetEvent('qbx-skilltree:client:openMenu', openSkillTreeHud)

RegisterCommand(Config.Commands.open, openSkillTreeHud)

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

RegisterNUICallback('allocateNode', function(data, cb)
    local treeId = data and data.treeId
    local nodeId = data and data.nodeId

    if not treeId or not nodeId then
        cb({ ok = false, error = Lang:t('error.invalid_node') })
        return
    end

    QBCore.Functions.TriggerCallback('qbx-skilltree:server:allocateNode', function(ok, result, detail)
        if ok then
            cb({
                ok = true,
                menuData = result,
            })
            return
        end

        cb({
            ok = false,
            error = Lang:t('error.' .. result, { detail = detail or '' }),
        })
    end, treeId, nodeId)
end)

RegisterNUICallback('respec', function(_, cb)
    QBCore.Functions.TriggerCallback('qbx-skilltree:server:respec', function(ok, result)
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
    end)
end)

CreateThread(function()
    Wait(1000)
    refreshSkillTreeHud()
end)
