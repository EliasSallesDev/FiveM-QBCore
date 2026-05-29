local QBCore = exports['qb-core']:GetCoreObject()
local ActiveMission = 0

RegisterServerEvent('AttackTransport:akceptujto', function()
	local copsOnDuty = 0
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	local accountMoney = xPlayer.PlayerData.money['bank']
	if ActiveMission == 0 then
		if accountMoney < Config.ActivationCost then
			TriggerClientEvent('QBCore:Notify', _source, 'Voce precisa de ' .. Config.Currency .. '' .. Config.ActivationCost .. ' no banco para aceitar a missao')
		else
			for _, v in pairs(QBCore.Functions.GetPlayers()) do
				local Player = QBCore.Functions.GetPlayer(v)
				if Player ~= nil then
					if (Player.PlayerData.job.name == 'police' or Player.PlayerData.job.type == 'leo') and Player.PlayerData.job.onduty then
						copsOnDuty = copsOnDuty + 1
					end
				end
			end
			if copsOnDuty >= Config.ActivePolice then
				TriggerClientEvent('AttackTransport:Pozwolwykonac', _source)
				xPlayer.Functions.RemoveMoney('bank', Config.ActivationCost, 'armored-truck')
				OdpalTimer()
			else
				TriggerClientEvent('QBCore:Notify', _source, 'E necessario pelo menos ' .. Config.ActivePolice .. ' policiais para ativar a missao.')
			end
		end
	else
		TriggerClientEvent('QBCore:Notify', _source, 'Alguem ja esta realizando esta missao')
	end
end)

RegisterServerEvent('qb-armoredtruckheist:server:callCops', function(streetLabel, coords)
	-- local place = "Armored Truck"
	-- local msg = "The Alarm has been activated from a "..place.. " at " ..streetLabel
	-- Why is this unused?
	TriggerClientEvent('qb-armoredtruckheist:client:robberyCall', -1, streetLabel, coords)
end)

function OdpalTimer()
	ActiveMission = 1
	Wait(Config.ResetTimer * 1000)
	ActiveMission = 0
	TriggerClientEvent('AttackTransport:CleanUp', -1)
end

RegisterServerEvent('AttackTransport:zawiadompsy', function(x, y, z)
	TriggerClientEvent('AttackTransport:InfoForLspd', -1, x, y, z)
end)

RegisterServerEvent('AttackTransport:graczZrobilnapad', function()
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(_source)
	local bags = math.random(1, 3)
	local info = {
		worth = math.random(Config.Payout.Min, Config.Payout.Max)
	}
	exports['qb-inventory']:AddItem(_source, 'markedbills', bags, false, info, 'AttackTransport:graczZrobilnapad')
	TriggerClientEvent('qb-inventory:client:ItemBox', _source, QBCore.Shared.Items['markedbills'], 'add')

	local chance = math.random(1, 100)
	TriggerClientEvent('QBCore:Notify', _source, 'Voce pegou ' .. bags .. ' bolsas de dinheiro da van')

	if chance >= 95 then
		exports['qb-inventory']:AddItem(_source, 'security_card_01', 1, false, false, 'AttackTransport:graczZrobilnapad')
		TriggerClientEvent('qb-inventory:client:ItemBox', _source, QBCore.Shared.Items['security_card_01'], 'add')
	end
	Wait(2500)
end)
