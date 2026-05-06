extends Node2D

# Aqui pegamos as referências do que está na cena
@onready var caixa_dialogo = $CanvasLayer/CaixaDialogo
@onready var carro = $cars

func _ready():
	var historia = [
{
			"nome": "Mãe",
			"texto": "Vou ter que esticar o turno hoje.",
			"sprite": preload("res://sprites/mother.jpg")
		},
		{
			"nome": "Mãe",
			"texto": "Você volta de ônibus.",
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
			"texto": "Ok...",
			"sprite": preload("res://sprites/personagemprincipal.jpg")
		},
		{
			"nome": "Protagonista",
			"texto": "Tudo bem, eu dou um jeito.",
			"sprite": preload("res://sprites/personagemprincipal.jpg")
		}
	]
	
	# Se esses nós existirem com esses nomes, vai funcionar:
	if caixa_dialogo:
		caixa_dialogo.iniciar_dialogo(historia)
	
	if carro:
		carro.movendo = true
