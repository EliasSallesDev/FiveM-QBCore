local activeTextResource = nil

local function getInvokingResource()
    return GetInvokingResource and GetInvokingResource() or GetCurrentResourceName()
end

local function hideText(forceOrOwner)
    local force = forceOrOwner == true
    local invokingResource = type(forceOrOwner) == 'string' and forceOrOwner or getInvokingResource()

    if not force and activeTextResource and invokingResource ~= activeTextResource then
        return
    end

    activeTextResource = nil
    SendNUIMessage({
        action = 'HIDE_TEXT',
    })
end

local function normalizeTextArgs(position, ownerResource)
    if ownerResource == nil and type(position) == 'string' and (position:match('^qb%-') or position:match('^qbx%-')) then
        return 'left', position
    end

    if type(position) ~= 'string' then position = 'left' end

    return position, ownerResource
end

local function drawText(text, position, ownerResource)
    position, ownerResource = normalizeTextArgs(position, ownerResource)

    activeTextResource = ownerResource or getInvokingResource()

    SendNUIMessage({
        action = 'DRAW_TEXT',
        data = {
            text = text,
            position = position
        }
    })
end

local function changeText(text, position, ownerResource)
    position, ownerResource = normalizeTextArgs(position, ownerResource)

    activeTextResource = ownerResource or getInvokingResource()

    SendNUIMessage({
        action = 'CHANGE_TEXT',
        data = {
            text = text,
            position = position
        }
    })
end

local function keyPressed()
    CreateThread(function()
        local pressedTextResource = activeTextResource

        SendNUIMessage({
            action = 'KEY_PRESSED',
        })

        Wait(500)

        if not pressedTextResource or activeTextResource == pressedTextResource then
            hideText(true)
        end
    end)
end

RegisterNetEvent('qb-core:client:DrawText', function(text, position)
    drawText(text, position)
end)

RegisterNetEvent('qb-core:client:ChangeText', function(text, position)
    changeText(text, position)
end)

RegisterNetEvent('qb-core:client:HideText', function()
    hideText()
end)

RegisterNetEvent('qb-core:client:KeyPressed', function()
    keyPressed()
end)

exports('DrawText', drawText)
exports('ChangeText', changeText)
exports('HideText', hideText)
exports('KeyPressed', keyPressed)
