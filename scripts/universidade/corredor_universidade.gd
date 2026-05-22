extends Node2D

# UI
@onready var panel = $CanvasLayer/Panel
@onready var label = $CanvasLayer/Panel/VBoxContainer/LabelSituacao

@onready var botao_a = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoA
@onready var botao_b = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoB

@onready var texto_botao_a = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoA/Label
@onready var texto_botao_b = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoB/Label


# HUD
@onready var hud = get_node_or_null("HudCorredor")


# Player
@onready var protagonista = $Protagonista


# Destinos
@onready var destino_banheiro = get_node_or_null("DestinoBanheiro")
@onready var destino_sala = get_node_or_null("DestinoSala")


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

	await _cutscene_inicio()

	await iniciar_hud()

	cutscene_rodando = false
	protagonista.pode_andar = true


# CUTSCENE INICIAL
func _cutscene_inicio():
	cutscene_rodando = true
	panel.visible = false

	await Cutscene.play_fade_out(0.0)
	
	await Cutscene.show_text("PRIMEIRO DIA", 2.0) 

	await Cutscene.play_fade_in(1.0)
	cutscene_rodando = false


# HUD DE INTRO
func iniciar_hud():

	if hud == null:
		print("HUD não encontrado")
		return

	var falas = [
		"Tem muita gente aqui.",
		"Onde eu ponho as mãos?? Será que eu tô andando esquisito??",
		"Meu Deus a sala é do outro lado do campus.",
		"... como que eu vou atravessar esse lugar desviando de todo mundo??",
		"Talvez eu devesse ir no banheiro primeiro. Só pra enrolar um pouco.",
		"Não, se eu fizer isso vou me atrasar. Vai, anda.",
		"Queria achar um daqueles gatinhos do campus...",
		"Fazer carinho neles é a única coisa que abaixa meu batimento cardíaco.",
		"Por que eu tenho que ser tão estranha?.."
	]
	for fala in falas:
		hud.show_message(fala)
		await hud.avancar_dialogo
		
	await hud.hide_message()

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

	GameState.definir_rota("colorida")
	GameState.alterar_estado(20, -20, 25, 30, 0)

	print("Escolheu sala")
	print("Rota: ", GameState.rota_atual)
	print("Ansiedade: ", GameState.ansiedade)
	print("Isolamento: ", GameState.isolamento)
	print("Confiança: ", GameState.confianca)
	print("Vínculo Colorida: ", GameState.vinculo_colorida)

	panel.visible = false
	escolha_ativa = false

	get_tree().change_scene_to_file("res://scenes/universidade/CenaSala.tscn")


# OPÇÃO BANHEIRO
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

	if destino_banheiro == null:
		print("ERRO: DestinoBanheiro não encontrado")
		return

	protagonista.destino = destino_banheiro.global_position

	protagonista.trocar_cena = true
	protagonista.cena_destino = "res://scenes/universidade/CenaBanheiro.tscn"
