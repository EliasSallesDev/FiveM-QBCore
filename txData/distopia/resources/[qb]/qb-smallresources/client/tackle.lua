local QBCore

local function GetQBCore()
    if QBCore then return QBCore end

    while GetResourceState('qb-core') ~= 'started' do
        Wait(100)
    end

    while not QBCore do
        local ok, core = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if ok and core then
            QBCore = core
        else
            Wait(100)
        end
    end

    return QBCore
end

CreateThread(function()
    GetQBCore()
end)

local function tackleAnim()
    local ped = PlayerPedId()
    if not HasAnimDictLoaded("swimming@first_person@diving") then
        RequestAnimDict("swimming@first_person@diving")
        while not HasAnimDictLoaded("swimming@first_person@diving") do
            Wait(10)
        end
    end
    if IsEntityPlayingAnim(ped, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
        ClearPedTasksImmediately(ped)
    else
        TaskPlayAnim(ped, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3.0, 3.0, -1, 49, 0, false, false, false)
        Wait(250)
        ClearPedTasksImmediately(ped)
        SetPedToRagdoll(ped, 150, 150, 0, false, false, false)
    end
end

RegisterCommand('tackle', function()
    local core = GetQBCore()
    if not core or not core.Functions then return end

    local ok, closestPlayer, distance = pcall(core.Functions.GetClosestPlayer)
    if not ok then return end

    local ped = PlayerPedId()
    local playerData = core.Functions.GetPlayerData()
    local metadata = playerData and playerData.metadata or {}
    if distance ~= -1 and distance < 2 and GetEntitySpeed(ped) > 2.5 and not IsPedInAnyVehicle(ped, false) and not metadata.ishandcuffed and not IsPedRagdoll(ped) then
        TriggerServerEvent("tackle:server:TacklePlayer", GetPlayerServerId(closestPlayer))
        tackleAnim()
    end
end)

RegisterKeyMapping('tackle', 'Tackle Someone', 'KEYBOARD', 'LMENU')

RegisterNetEvent('tackle:client:GetTackled', function()
    SetPedToRagdoll(PlayerPedId(), math.random(1000, 6000), math.random(1000, 6000), 0, false, false, false)
    TimerEnabled = true
    Wait(1500)
    TimerEnabled = false
end)
