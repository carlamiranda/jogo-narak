extends Node2D

# UI
@onready var panel = $CanvasLayer/Panel
@onready var label = $CanvasLayer/Panel/VBoxContainer/LabelSituacao

@onready var botao_a = $CanvasLayer/Panel/VBoxContainer/ButtonOpcaoA
@onready var botao_b = $CanvasLayer/Panel/VBoxContainer/ButtonOpcaoB

@onready var texto_botao_a = $CanvasLayer/Panel/VBoxContainer/ButtonOpcaoA/Label
@onready var texto_botao_b = $CanvasLayer/Panel/VBoxContainer/ButtonOpcaoB/Label


# HUD
@onready var hud = get_node_or_null("HudCorredor")


# Player
@onready var protagonista = $Protagonista


# Destino
@onready var destino_banheiro = get_node_or_null("DestinoBanheiro")


# Estado
var escolha_ativa := false
var cutscene_rodando := false
var cutscene_feita := false


func _ready():

	panel.visible = false

	botao_a.pressed.connect(_ir_sala)
	botao_b.pressed.connect(_ir_banheiro)

	protagonista.pode_andar = false
	protagonista.andando_automatico = false
	protagonista.trocar_cena = false

	await get_tree().process_frame
	await get_tree().process_frame

	# CUTSCENE ATIVA DE NOVO
	await _cutscene_inicio()

	await iniciar_hud()

	cutscene_rodando = false
	protagonista.pode_andar = true


# CUTSCENE INICIAL
func _cutscene_inicio():

	cutscene_rodando = true

	panel.visible = false

	await Cutscene.play_fade_out(0.0)

	await Cutscene.show_text("PRIMEIRO DIA", 1.5)
	await Cutscene.show_text("O carro ficou para trás.", 2.0)
	await Cutscene.show_text("Ela está na faculdade agora.", 2.5)
	await Cutscene.show_text("Mas algo no peito aperta.", 2.5)
	await Cutscene.show_text("Não é medo… é ansiedade.", 3.0)

	await Cutscene.play_fade_in(1.0)

	cutscene_rodando = false


# HUD DE INTRO
func iniciar_hud():

	if hud == null:
		print("HUD não encontrado")
		return

	await hud.show_message("Hoje não é um dia comum.", 2.5)
	await hud.show_message("Algo precisa ser decidido agora.", 3.0)
	await hud.show_message("A sala de aula está logo à frente.", 2.5)
	await hud.show_message("A porta da sala marca o início das suas escolhas.", 4.0)
	await hud.show_message("Quando estiver pronta, aproxime-se dela.", 3.5)


# PORTA
func _on_porta_sala_body_entered(body):

	if body != protagonista:
		return

	if cutscene_rodando:
		return

	ativar_ui()


# UI DE ESCOLHA
func ativar_ui():

	if escolha_ativa:
		return

	escolha_ativa = true

	protagonista.pode_andar = false
	protagonista.velocity = Vector2.ZERO

	panel.visible = true

	label.text = "Você está no corredor. O que fazer?"
	texto_botao_a.text = "Entrar na sala"
	texto_botao_b.text = "Ir ao banheiro"


# OPÇÃO SALA
func _ir_sala():

	panel.visible = false
	escolha_ativa = false

	protagonista.pode_andar = true


# OPÇÃO BANHEIRO
func _ir_banheiro():

	panel.visible = false
	escolha_ativa = false

	protagonista.pode_andar = false
	protagonista.andando_automatico = true

	if destino_banheiro == null:
		print("ERRO: DestinoBanheiro não encontrado")
		return

	protagonista.destino = destino_banheiro.global_position

	protagonista.trocar_cena = true
	protagonista.cena_destino = "res://scenes/universidade/CenaBanheiro.tscn"
