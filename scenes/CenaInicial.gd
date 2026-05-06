extends Node2D

var dialogo_scene = preload("res://scenes/Dialogo.tscn")

func _ready():
	var d = dialogo_scene.instantiate()
	add_child(d)

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
		}
	]

	d.iniciar_dialogo(historia)
