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
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
jig = {}
Tunnel.bindInterface("jig_explorace",jig)
vCLIENT = Tunnel.getInterface("jig_explorace")

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO COMEÇAR CORRIDA
-----------------------------------------------------------------------------------------------------------------------------------------
function jig.comecarcorrida()
    local aceitou = vRP.request(source,"Tem certeza que deseja <b>iniciar</b> uma <b>corrida explosiva</b>?",30)
    if aceitou then
        return true
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO PARA ENTREGAR O DINHEIRO DA CORRIDA.
-----------------------------------------------------------------------------------------------------------------------------------------
function jig.pagaofeio(valor, item, bonus, perm)
	local source = source
	local user_id = vRP.getUserId(source)
	local policia = vRP.getUsersByPermission(perm)
	if user_id then
		if parseInt(#policia) == 0 then
			vRP.giveInventoryItem(user_id, item, valor, true)
			TriggerClientEvent("Notify",source,"sucesso","Você recebeu R$ "..valor.." em dinheiro sujo pela corrida explosiva!")
			TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
		elseif parseInt(#policia) > 1 then
			local extra = (valor + (bonus * policia))
			vRP.giveInventoryItem(user_id, item, extra, true)
			TriggerClientEvent("Notify",source,"sucesso","Você recebeu R$ "..extra.." em dinheiro sujo pela corrida explosiva!")
			TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO PARA AVISAR A POLICIA E MARCAR CORREDOR NO MAPA.
-----------------------------------------------------------------------------------------------------------------------------------------
function jig.avisapolicia()
	local source = source
	local policia = vRP.getUsersByPermission("policia.permissao")
	TriggerEvent('eblips:add',{ name = "Corredor", src = source, color = 83 })
	for k,v in pairs(policia) do
		local player = vRP.getUserSource(parseInt(v))
		if player then
			async(function()
				vRPclient.playSound(player,"Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
				TriggerClientEvent('chatMessage',player,"911",{65,130,255},"Encontramos um corredor ilegal na cidade, intercepte-o.")
			end)
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO PARA RETIRAR CORREDOR DO MAPA.
-----------------------------------------------------------------------------------------------------------------------------------------
function jig.tirablip()
	local source = source
	TriggerEvent('eblips:remove',source)
end