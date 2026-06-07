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
var avisando_panfleto := false 


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

	# LIBERA O PLAYER AQUI
	pode_jogar = true


# ================= CUTSCENE =================
func _cutscene_inicio():
	cutscene_rodando = true
	panel.visible = false

	await Cutscene.play_fade_out(0.0)
	await Cutscene.show_text("PRIMEIRO DIA", 2.0)
	await Cutscene.play_fade_in(1.0)

	cutscene_rodando = false
	
	# --- NOVA PARTE: Mostra a HUD depois que a tela preta some ---
	var hud_principal = get_node_or_null("HudPrincipal")
	if hud_principal and hud_principal.has_method("mostrar_hud"):
		hud_principal.mostrar_hud()


# ================= HUD =================
func iniciar_hud():

	if hud == null:
		print("HUD não encontrado")
		return

	var falas = []

	if GameState.ja_tentou_fase_1 == false:
		falas = [
			"Tem muita gente aqui.",
			"Onde eu ponho as mãos??",
			"... como vou atravessar isso?",
			"Eu preciso ir pra aula, acho que é seguindo reto aqui.",
			"Mas antes, tenho que pegar o panfleto com o número da minha sala.",
			"Disseram que fica na biblioteca... lá embaixo, mais pro meio do campus.",
			"Talvez eu devesse ir no banheiro primeiro pra me acalmar.",
			"Não, vou me atrasar se fizer isso. Primeiro a biblioteca. Foco.",
			"Por que tudo tem que ser tão difícil pra mim?.."
		]
	else:
		falas = [
			"É... vamos ver se agora eu consigo.",
			"Respira fundo, não olha para os lados.",
			"Eu preciso pegar o panfleto e chegar na sala."
		]

	for fala in falas:
		hud.show_message(fala)
		await hud.avancar_dialogo

	await hud.hide_message()


# ================= PORTA =================
func _on_porta_sala_body_entered(body):

	if body != protagonista:
		return

	if cutscene_rodando or avisando_panfleto:
		return

	var hud_principal = get_node_or_null("HudPrincipal")
	var tem_panfleto = false
	
	if hud_principal != null:
		tem_panfleto = hud_principal.tem_papel
		
	if tem_panfleto:
		ativar_ui()
	else:
		avisando_panfleto = true
		if hud != null:
			hud.show_message("Não posso entrar ainda. O panfleto com a minha sala deve estar lá embaixo, na biblioteca.")
			await hud.avancar_dialogo
			await hud.hide_message()
		avisando_panfleto = false


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
