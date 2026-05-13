extends Node2D

@onready var panel = $CanvasLayer/Panel
@onready var label = $CanvasLayer/Panel/VBoxContainer/LabelSituacao
@onready var botao_a = $CanvasLayer/Panel/VBoxContainer/ButtonOpcaoA
@onready var botao_b = $CanvasLayer/Panel/VBoxContainer/ButtonOpcaoB

@onready var fade = $CanvasLayer/Fade
@onready var titulo = $CanvasLayer/TituloIntro

@onready var protagonista = $Protagonista
@onready var destino_banheiro = $PortaBanheiro/DestinoBanheiro

var escolha_ativa := false


func _ready():
	fade.color.a = 1.0

	await intro_titulo()
	await fade_in()

	panel.visible = false

	botao_a.pressed.connect(_ir_sala)
	botao_b.pressed.connect(_ir_banheiro)


func intro_titulo():
	titulo.visible = true
	titulo.modulate.a = 0.0

	var t := 0.0

	while t < 1.0:
		t += 0.02
		titulo.modulate.a = t
		await get_tree().process_frame

	await get_tree().create_timer(1.2).timeout

	while t > 0.0:
		t -= 0.02
		titulo.modulate.a = t
		await get_tree().process_frame

	titulo.visible = false


func fade_in():
	fade.visible = true
	var t := 0.0

	while t < 1.0:
		t += 0.02
		fade.color.a = 1.0 - t
		await get_tree().process_frame

	fade.visible = false


func fade_out():
	fade.visible = true
	var t := 0.0

	while t < 1.0:
		t += 0.02
		fade.color.a = t
		await get_tree().process_frame


func ativar_ui():
	if escolha_ativa:
		return

	escolha_ativa = true

	protagonista.pode_andar = false
	protagonista.velocity = Vector2.ZERO

	panel.visible = true

	label.text = "Você está no corredor. O que fazer?"
	botao_a.text = "Entrar na sala"
	botao_b.text = "Ir ao banheiro"


func _ir_sala():
	GameState.definir_rota("colorida")
	GameState.alterar_estado(20, -20, 25, 30, 0)

	print("Escolheu sala")
	print("Rota: ", GameState.rota_atual)
	print("Ansiedade: ", GameState.ansiedade)
	print("Isolamento: ", GameState.isolamento)
	print("Confiança: ", GameState.confianca)
	print("Vínculo Colorida: ", GameState.vinculo_colorida)
	print("Vínculo Quebrada: ", GameState.vinculo_quebrada)

	panel.visible = false
	escolha_ativa = false
	protagonista.pode_andar = true

	# Por enquanto, continua no corredor.
	# Depois podemos mandar para uma cena da sala.
	# get_tree().change_scene_to_file("res://scenes/CenaSala.tscn")


func _ir_banheiro():
	GameState.definir_rota("espelho")
	GameState.alterar_estado(-10, 30, 0, 0, 30)

	print("Escolheu banheiro")
	print("Rota: ", GameState.rota_atual)
	print("Ansiedade: ", GameState.ansiedade)
	print("Isolamento: ", GameState.isolamento)
	print("Confiança: ", GameState.confianca)
	print("Vínculo Colorida: ", GameState.vinculo_colorida)
	print("Vínculo Quebrada: ", GameState.vinculo_quebrada)

	panel.visible = false
	escolha_ativa = false

	protagonista.pode_andar = false
	protagonista.andando_automatico = true
	protagonista.destino = destino_banheiro.global_position

	protagonista.trocar_cena = true
	protagonista.cena_destino = "res://scenes/CenaBanheiro.tscn"
