extends Node2D

@onready var dialogo = $CanvasLayer/CaixaDialogoBanheiro
@onready var protagonista = $Banheiro/Protagonista
@onready var fade = $CanvasLayer/Fade
@onready var titulo = $CanvasLayer/TituloRefugio

func _ready():
	fade.visible = true
	fade.color.a = 1.0

	titulo.visible = true
	titulo.modulate.a = 0.0

	dialogo.visible = false
	protagonista.pode_andar = false

	await intro_titulo()
	await fade_in()

	iniciar_dialogo()

func iniciar_dialogo():
	dialogo.visible = true

	dialogo.iniciar_dialogo([
		{
			"nome":"Protagonista",
			"texto":"Respira.",
			"sprite": preload("res://sprites/personagemprincipal.jpg")
		},
		{
			"nome":"Protagonista",
			"texto":"É só uma sala.",
			"sprite": preload("res://sprites/personagemprincipal.jpg")
		},
		{
			"nome":"Protagonista",
			"texto":"Então por que parece que eu vou morrer se entrar lá?",
			"sprite": preload("res://sprites/personagemprincipal.jpg")
		},
		{
			"nome":"Protagonista",
			"texto":"...",
			"sprite": preload("res://sprites/personagemprincipal.jpg")
		},
		{
			"nome":"Protagonista",
			"texto":"Eu só precisava de silêncio por um minuto.",
			"sprite": preload("res://sprites/personagemprincipal.jpg")
		}
	])

	await dialogo.tree_exited
	protagonista.pode_andar = true

func intro_titulo():
	titulo.text = "O Refúgio no Banheiro"
	var t = 0.0

	while t < 1.0:
		t += 0.03
		titulo.modulate.a = t
		await get_tree().process_frame

	await get_tree().create_timer(1.2).timeout

	while t > 0.0:
		t -= 0.03
		titulo.modulate.a = t
		await get_tree().process_frame

	titulo.visible = false

func fade_in():
	var t = 0.0

	while t < 1.0:
		t += 0.03
		fade.color.a = 1.0 - t
		await get_tree().process_frame

	fade.visible = false
