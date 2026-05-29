local QBCore = exports['qb-core']:GetCoreObject()

-- Get Employees
QBCore.Functions.CreateCallback('qb-gangmenu:server:GetEmployees', function(source, cb, gangname)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if not Player.PlayerData.gang.isboss then
		ExploitBan(src, 'GetEmployees Exploiting')
		return
	end

	local employees = {}
	local players = MySQL.query.await("SELECT * FROM `players` WHERE `gang` LIKE '%" .. gangname .. "%'", {})
	if players[1] ~= nil then
		for _, value in pairs(players) do
			local Target = QBCore.Functions.GetPlayerByCitizenId(value.citizenid) or QBCore.Functions.GetOfflinePlayerByCitizenId(value.citizenid)

			if Target then
				local isOnline = Target.PlayerData.source
				employees[#employees + 1] = {
					empSource = Target.PlayerData.citizenid,
					grade = Target.PlayerData.gang.grade,
					isboss = Target.PlayerData.gang.isboss,
					name = (isOnline and '🟢 ' or '❌ ') .. Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname
				}
			end
		end
	end
	cb(employees)
end)

RegisterNetEvent('qb-gangmenu:server:stash', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if not Player then return end
	local playerGang = Player.PlayerData.gang
	if not playerGang.isboss then return end
	local playerPed = GetPlayerPed(src)
	local playerCoords = GetEntityCoords(playerPed)
	if not Config.GangMenus[playerGang.name] then return end
	local bossCoords = Config.GangMenus[playerGang.name]
	for i = 1, #bossCoords do
		local coords = bossCoords[i]
		if #(playerCoords - coords) < 2.5 then
			local stashName = 'boss_' .. playerGang.name
			exports['qb-inventory']:OpenInventory(src, stashName, {
				maxweight = 4000000,
				slots = 25,
			})
			return
		end
	end
end)

-- Grade Change
RegisterNetEvent('qb-gangmenu:server:GradeUpdate', function(data)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Employee = QBCore.Functions.GetPlayerByCitizenId(data.cid) or QBCore.Functions.GetOfflinePlayerByCitizenId(data.cid)

	if not Player.PlayerData.gang.isboss then
		ExploitBan(src, 'GradeUpdate Exploiting')
		return
	end
	if data.grade > Player.PlayerData.gang.grade.level then
		TriggerClientEvent('QBCore:Notify', src, 'Voce nao pode promover para este cargo!', 'error')
		return
	end

	if Employee then
		if Employee.Functions.SetGang(Player.PlayerData.gang.name, data.grade) then
			TriggerClientEvent('QBCore:Notify', src, 'Promovido com sucesso!', 'success')
			Employee.Functions.Save()

			if Employee.PlayerData.source then
				TriggerClientEvent('QBCore:Notify', Employee.PlayerData.source, 'Voce foi promovido para ' .. data.gradename .. '.', 'success')
			end
		else
			TriggerClientEvent('QBCore:Notify', src, 'Esse grau nao existe.', 'error')
		end
	end
	TriggerClientEvent('qb-gangmenu:client:OpenMenu', src)
end)

-- Fire Member
RegisterNetEvent('qb-gangmenu:server:FireMember', function(target)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Employee = QBCore.Functions.GetPlayerByCitizenId(target) or QBCore.Functions.GetOfflinePlayerByCitizenId(target)

	if not Player.PlayerData.gang.isboss then
		ExploitBan(src, 'FireEmployee Exploiting')
		return
	end

	if Employee then
		if target == Player.PlayerData.citizenid then
			TriggerClientEvent('QBCore:Notify', src, 'Voce nao pode expulsar a si mesmo da gangue!', 'error')
			return
		elseif Employee.PlayerData.gang.grade.level > Player.PlayerData.gang.grade.level then
			TriggerClientEvent('QBCore:Notify', src, 'Voce nao pode expulsar este cidadao!', 'error')
			return
		end
		if Employee.Functions.SetGang('none', '0') then
			Employee.Functions.Save()
			TriggerEvent('qb-log:server:CreateLog', 'gangmenu', 'Gang Fire', 'orange', Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname .. ' successfully fired ' .. Employee.PlayerData.charinfo.firstname .. ' ' .. Employee.PlayerData.charinfo.lastname .. ' (' .. Player.PlayerData.gang.name .. ')', false)
			TriggerClientEvent('QBCore:Notify', src, 'Membro da gangue expulso!', 'success')

			if Employee.PlayerData.source then -- Player is online
				TriggerClientEvent('QBCore:Notify', Employee.PlayerData.source, 'Voce foi expulso da gangue!', 'error')
			end
		else
			TriggerClientEvent('QBCore:Notify', src, 'Erro.', 'error')
		end
	end
	TriggerClientEvent('qb-gangmenu:client:OpenMenu', src)
end)

-- Recruit Player
RegisterNetEvent('qb-gangmenu:server:HireMember', function(recruit)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Target = QBCore.Functions.GetPlayer(recruit)

	if not Player.PlayerData.gang.isboss then
		ExploitBan(src, 'HireEmployee Exploiting')
		return
	end

	if Target and Target.Functions.SetGang(Player.PlayerData.gang.name, 0) then
		TriggerClientEvent('QBCore:Notify', src, 'Voce recrutou ' .. (Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname) .. ' para ' .. Player.PlayerData.gang.label, 'success')
		TriggerClientEvent('QBCore:Notify', Target.PlayerData.source, 'Voce foi recrutado para ' .. Player.PlayerData.gang.label, 'success')
		TriggerEvent('qb-log:server:CreateLog', 'gangmenu', 'Recruit', 'yellow', (Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname) .. ' successfully recruited ' .. Target.PlayerData.charinfo.firstname .. ' ' .. Target.PlayerData.charinfo.lastname .. ' (' .. Player.PlayerData.gang.name .. ')', false)
	end
	TriggerClientEvent('qb-gangmenu:client:OpenMenu', src)
end)

-- Get closest player sv
QBCore.Functions.CreateCallback('qb-gangmenu:getplayers', function(source, cb)
	local src = source
	local players = {}
	local PlayerPed = GetPlayerPed(src)
	local pCoords = GetEntityCoords(PlayerPed)
	for _, v in pairs(QBCore.Functions.GetPlayers()) do
		local targetped = GetPlayerPed(v)
		local tCoords = GetEntityCoords(targetped)
		local dist = #(pCoords - tCoords)
		if PlayerPed ~= targetped and dist < 10 then
			local ped = QBCore.Functions.GetPlayer(v)
			players[#players + 1] = {
				id = v,
				coords = GetEntityCoords(targetped),
				name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname,
				citizenid = ped.PlayerData.citizenid,
				sources = GetPlayerPed(ped.PlayerData.source),
				sourceplayer = ped.PlayerData.source
			}
		end
	end
	table.sort(players, function(a, b)
		return a.name < b.name
	end)
	cb(players)
end)
