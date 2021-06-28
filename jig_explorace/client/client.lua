-------------------------------------------------------
--------- Resource = "jig_explorace" (Corridas explosivas!)
--------- Autor = jigsaw
--------- Github = https://github.com/jigbr
--------- Discord = jigsaw#2247
--------- Loja Discord = https://discord.gg/7xzbUeU
-------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
jig = {}
Tunnel.bindInterface("jig_explorace",jig)
jig = Tunnel.getInterface("jig_explorace")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGS
-----------------------------------------------------------------------------------------------------------------------------------------
local incorrida = false
local tempocorrida = 0
local bomba = nil
local tempo = 0
local blips = false
local selecionada = 0
local selecionado = 0

-----------------------------------------------------------------------------------------------------------------------------------------
-- SCRIPT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local idle = 1000
		if not incorrida then
			local ped = PlayerPedId()
			local distance = GetEntityCoords(ped)
			if #(distance - vector3(jigconfig.configs.x, jigconfig.configs.y, jigconfig.configs.z)) <= 15 then
				idle = 1
				DrawMarker(36, jigconfig.configs.x, jigconfig.configs.y, jigconfig.configs.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 63, 56, 162, 255, true, false, 2, true)
				DrawMarker(25, jigconfig.configs.x , jigconfig.configs.y, jigconfig.configs.z-0.97, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 63, 56, 162, 255, false, false, 2, false)
				if IsControlJustPressed(0, 38) then
					local jigperguntou = jig.comecarcorrida()
					if jigperguntou == true then
						selecionada = math.random(#jigconfig.corridas)
						tempocorrida = jigconfig.corridas[selecionada].tempo
						incorrida = true
						selecionado = math.random(#jigconfig.carros)
						veic = spawnVehicle(jigconfig.carros[selecionado].modelo, jigconfig.carros[selecionado].x, jigconfig.carros[selecionado].y, jigconfig.carros[selecionado].z, jigconfig.carros[selecionado].h)
						CriandoBlip(jigconfig.corridas,selecionada)
						jig.avisapolicia()
						bomba = CreateObject(GetHashKey("prop_c4_final"),jigconfig.corridas[selecionada].x,jigconfig.corridas[selecionada].y,jigconfig.corridas[selecionada].z+0.39,true,false,false)
						AttachEntityToEntity(bomba,veic,GetEntityBoneIndexByName(veic,"exhaust"),0.0,0.0,0.0,180.0,-90.0,180.0,false,false,false,true,2,true)
						TriggerEvent("Notify","sucesso","Corrida <b>INICIADA</b>, entre e não saia do veículo! Chegue no destino dentro do tempo ou <b>EXPLODA!</b>",8000)	
						while not IsPedInVehicle(ped, veic, false) do
							Wait(1)
							DrawMarker(0, jigconfig.carros[selecionado].x, jigconfig.carros[selecionado].y, jigconfig.carros[selecionado].z+1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 63, 56, 162, 255, true, false, 2, true)
						end
						while true do
							Wait(1)
							if IsPedInVehicle(ped, veic, false) then
								local distance = GetEntityCoords(ped)
								local distancia = #(distance - vector3(jigconfig.corridas[selecionada].x, jigconfig.corridas[selecionada].y, jigconfig.corridas[selecionada].z))
								if distancia < 50 then
									DrawMarker(5, jigconfig.corridas[selecionada].x, jigconfig.corridas[selecionada].y, jigconfig.corridas[selecionada].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.5, 2.5, 2.5, 0, 0, 0, 255, true, false, 2, true)
									if distancia < 10 then
										if IsControlPressed(0, 38) then
											if GetVehiclePedIsUsing(ped) == veic then
												incorrida = false
												RemoveBlip(blips)
												jig.pagaofeio(jigconfig.corridas[selecionada].pagamento, jigconfig.configs.item, jigconfig.configs.bonus, jigconfig.configs.permissao)
												jig.tirablip()
												DeleteObject(bomba)
												break
											else
												TriggerEvent("Notify","negado","O VEICULO É DIFERENTE DO COMBINADO, MANÉ!",8000)
											end
										end
									end
								end
							end
						end
					else
						TriggerEvent("Notify","negado","Corrida recusada! talvez outro dia?",8000)
					end
				end
			end
		end
		Wait(idle)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TEMPO DA CORRIDA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(1000)
		if incorrida and tempocorrida > 0 then
			tempocorrida = tempocorrida - 1
			if tempocorrida <= 0 then
				incorrida = false
				RemoveBlip(blips)
				SetTimeout(3000,function()
					DetachEntity(bomba,false,false)
					TriggerServerEvent("trydeleteobj",ObjToNet(bomba))
					jig.tirablip()
					AddExplosion(GetEntityCoords(veic),1,1.0,true,true,true)
				end)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CRONOMETRO DA CORRIDA
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		idle = 1000
		if incorrida and tempocorrida > 0 then
			idle = 1
			drawTxt("RESTAM ~b~"..tempocorrida.." SEGUNDOS ~w~PARA A BOMBA EXPLODIR!",0.5,0.905,0.45,100)
			drawTxt("CHEGUE AO DESTINO ANTES DO TEMPO OU MORRA!",0.5,0.93,0.38,70)
		end
		Wait(idle)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO DE SPAWNAR O VEÍCULO
-----------------------------------------------------------------------------------------------------------------------------------------
function spawnVehicle(name,x,y,z,h)
	local mhash = GetHashKey(name)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Wait(10)
	end
	if HasModelLoaded(mhash) then
		local nveh = CreateVehicle(mhash,x,y,z+0.5,h,true,false)
		NetworkRegisterEntityAsNetworked(nveh)
		while not NetworkGetEntityIsNetworked(nveh) do
			NetworkRegisterEntityAsNetworked(nveh)
			Wait(1)
		end
		SetVehicleOnGroundProperly(nveh)
		SetVehicleAsNoLongerNeeded(nveh)
		SetVehicleIsStolen(nveh,false)
		SetVehicleNeedsToBeHotwired(nveh,false)
		SetEntityInvincible(nveh,false)
		SetVehicleNumberPlateText(nveh,vRP.getRegistrationNumber())
		SetVehicleHasBeenOwnedByPlayer(nveh,true)
		SetVehRadioStation(nveh,"OFF")
		local v = VehToNet(nveh)
		SetVehicleDoorsLocked(nveh,false)
		SetVehicleDoorsLockedForAllPlayers(nveh,false)
		TriggerServerEvent('TryDoorsEveryone',nveh,0,GetVehicleNumberPlateText(nveh))
		SetModelAsNoLongerNeeded(mhash)
		return nveh
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GPS DA CORRIDA
-----------------------------------------------------------------------------------------------------------------------------------------
function CriandoBlip(corridas,selecionada)
	blips = AddBlipForCoord(jigconfig.corridas[selecionada].x,jigconfig.corridas[selecionada].y,jigconfig.corridas[selecionada].z)
	SetBlipSprite(blips,315)
	SetBlipColour(blips,1)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("CORRIDA EXPLOSIVA")
	EndTextCommandSetBlipName(blips)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO DO CRONOMETRO
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(4)
	SetTextScale(0.39, 0.39)
	SetTextColour(0,0,0,255)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO DO CRONOMETRO
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,x,y,scale,a)
	SetTextFont(4)
	SetTextScale(scale, scale)
	SetTextColour(255,255,255,a)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end