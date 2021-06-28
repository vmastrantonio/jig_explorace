-------------------------------------------------------
--------- Resource = "jig_explorace" (Corridas explosivas!)
--------- Autor = jigsaw
--------- Github = https://github.com/jigbr
--------- Discord = jigsaw#2247
--------- Loja Discord = https://discord.gg/7xzbUeU
-------------------------------------------------------

fx_version 'bodacious'
games { 'rdr3', 'gta5' }

author 'https://github.com/jigbr'
description 'Script de corrida EXPLOSIVA!'
version '1.0.0'

server_scripts {
	"@vrp/lib/utils.lua",
	'server/server.lua'
}

client_scripts {
	"@vrp/lib/utils.lua",
	'config.lua',
	'client/client.lua'
}