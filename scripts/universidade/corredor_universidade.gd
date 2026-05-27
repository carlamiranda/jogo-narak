extends Node2D

# ================= UI =================
@onready var panel = $CanvasLayer/Panel
@onready var label = $CanvasLayer/Panel/VBoxContainer/LabelSituacao

@onready var botao_a = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoA
@onready var botao_b = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoB

@onready var texto_botao_a = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoA/Label
@onready var texto_botao_b = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoB/Label

# ================= HUD =================
@onready var hud = get_node_or_null("HudCorredor")

# ================= PLAYER =================
@onready var protagonista = $Protagonista

# ================= DESTINOS =================
@onready var destino_banheiro = get_node_or_null("DestinoBanheiro")
@onready var destino_sala = get_node_or_null("DestinoSala")

# ================= ESTADO =================
var escolha_ativa := false
var cutscene_rodando := false
var pode_jogar := false


# ================= READY =================
func _ready():

	panel.visible = false

	botao_a.pressed.connect(_ir_sala)
	botao_b.pressed.connect(_ir_banheiro)

	# trava no início
	pode_jogar = false
	protagonista.velocity = Vector2.ZERO

	await get_tree().process_frame
	await get_tree().process_frame

	await _cutscene_inicio()
	await iniciar_hud()

	# 🔥 LIBERA O PLAYER AQUI (isso é o que estava faltando)
	pode_jogar = true


# ================= CUTSCENE =================
func _cutscene_inicio():
	cutscene_rodando = true
	panel.visible = false

	await Cutscene.play_fade_out(0.0)
	await Cutscene.show_text("PRIMEIRO DIA", 2.0)
	await Cutscene.play_fade_in(1.0)

	cutscene_rodando = false


# ================= HUD =================
func iniciar_hud():

	if hud == null:
		print("HUD não encontrado")
		return

	var falas = [
		"Tem muita gente aqui.",
		"Onde eu ponho as mãos??",
		"Meu Deus a sala é do outro lado do campus.",
		"... como atravessar isso?",
		"Talvez eu devesse ir no banheiro primeiro.",
		"Não, vou me atrasar.",
		"Queria achar um gatinho do campus...",
		"Fazer carinho neles ajuda.",
		"Por que eu sou tão estranha?.."
	]

	for fala in falas:
		hud.show_message(fala)
		await hud.avancar_dialogo

	await hud.hide_message()


# ================= PORTA =================
func _on_porta_sala_body_entered(body):

	if body != protagonista:
		return

	if cutscene_rodando:
		return

	ativar_ui()


# ================= UI =================
func ativar_ui():

	if escolha_ativa:
		return

	escolha_ativa = true
	pode_jogar = false

	protagonista.velocity = Vector2.ZERO

	panel.visible = true

	label.text = "Você está no corredor. O que fazer?"
	texto_botao_a.text = "Entrar na sala"
	texto_botao_b.text = "Ir ao banheiro"


# ================= SALA =================
func _ir_sala():

	GameState.definir_rota("colorida")
	GameState.alterar_estado(20, -20, 25, 30, 0)

	panel.visible = false
	escolha_ativa = false
	pode_jogar = true

	get_tree().change_scene_to_file("res://scenes/universidade/CenaSala.tscn")


# ================= BANHEIRO =================
func _ir_banheiro():

	GameState.definir_rota("espelho")
	GameState.alterar_estado(-10, 30, 0, 0, 30)

	panel.visible = false
	escolha_ativa = false
	pode_jogar = true

	if destino_banheiro == null:
		print("ERRO: DestinoBanheiro não encontrado")
		return

	protagonista.global_position = destino_banheiro.global_position

	get_tree().change_scene_to_file("res://scenes/universidade/CenaBanheiro.tscn")
