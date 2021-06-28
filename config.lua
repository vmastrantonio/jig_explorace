-------------------------------------------------------
--------- Resource = "jig_explorace" (Corridas explosivas!)
--------- Autor = jigsaw
--------- Github = https://github.com/jigbr
--------- Discord = jigsaw#2247
--------- Loja Discord = https://discord.gg/7xzbUeU
-------------------------------------------------------

jigconfig = {}

jigconfig.configs = { 
	['x'] = -1037.61, ['y'] = -2737.55, ['z'] = 20.17, -- Cordenadas X,Y,Z do local onde o player iniciará alguma corrida aleatória.
	['item'] = "dinheiro-sujo", -- Nome de spawn do dinheiro sujo do seu servidor.
	['bonus'] = 500, -- Valor BONUS, pago A MAIS por CADA policial que estiver em serviço na hora de terminar a corrida.
	['permissao'] = "policia.permissao", -- Permissão da policia do seu servidor.
}

jigconfig.corridas = {
	[1] = { ['tempo'] = 25, ['pagamento'] = 100, ['x'] = -1012.15, ['y'] = -2740.74, ['z'] = 20.14 }, -- 'tempo' é a duração da corrida, 'pagamento' é o valor base recebido ao concluir a corrida, x,y,z é as cordenadas da linha de chegada da corrida.
}

jigconfig.carros = {
	[1] = { ['modelo'] = '911r', ['x'] = -1033.04, ['y'] = -2728.14, ['z'] = 20.17, ['h'] = 245.53 }, -- 'modelo' é o nome de spawn do veículo, x,y,z,h são as cordenadas de onde o veiculo vai spawnar e a direção para onde ele estará virado.
}