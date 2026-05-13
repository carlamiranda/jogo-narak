extends Node2D

@onready var caixa_dialogo = $CanvasLayer/CaixaDialogo
@onready var carro = $cars

func _ready():

	var historia = [
		{
			"nome": "Mãe",
			"texto": "Sim, eu sei do prazo! Mas isso não estava no cronograma original!",
			"sprite": preload("res://sprites/mother.jpg")
		},
		{
			"nome": "Mãe",
			"texto": "Não, não dá pra simplesmente empurrar isso pra semana que vem…",
			"sprite": preload("res://sprites/mother.jpg")
		},
		{
			"nome": "Mãe",
			"texto": "Eu estou a caminho agora. Depois resolvo isso no escritório.",
			"sprite": preload("res://sprites/mother.jpg")
		},

		{
			"nome": "Mãe",
			"texto": "*suspiro* Não era pra ser assim hoje.",
			"sprite": preload("res://sprites/mother.jpg")
		},

		{
			"nome": "Mãe",
			"texto": "Vou ter que esticar o turno hoje.",
			"sprite": preload("res://sprites/mother.jpg")
		},

		{
			"nome": "Mãe",
			"texto": "Você volta de ônibus, tudo bem?",
			"sprite": preload("res://sprites/mother.jpg")
		},

		{
			"nome": "Mãe",
			"texto": "Consegue se virar, né?",
			"sprite": preload("res://sprites/mother.jpg")
		},

		{
			"nome": "Protagonista",
			"texto": "...",
			"sprite": preload("res://sprites/personagemprincipal.jpg")
		},

		{
			"nome": "Protagonista",
			"texto": "Ok.",
			"sprite": preload("res://sprites/personagemprincipal.jpg")
		}
	]

	# inicia diálogo
	if caixa_dialogo:
		caixa_dialogo.iniciar_dialogo(historia)

	# inicia movimento do carro
	if carro:
		carro.movendo = true
