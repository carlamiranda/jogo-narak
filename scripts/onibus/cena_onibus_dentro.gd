extends Node2D

@onready var protagonista = $Protagonista
@onready var posicao_sentada = $PosicaoSentada
@onready var area_sentar = $AreaSentar
@onready var saida_onibus = $SaidaOnibus
@onready var hud = $HudOnibus

# CUTSCENE
@onready var cutscene = $CutsceneLayer

var rota := ""
var perto_do_banco := false
var ja_sentou := false
var pode_sair := false
var finalizado := false


func _ready() -> void:

	rota = GameState.rota_atual

	area_sentar.body_entered.connect(_on_area_sentar_body_entered)
	area_sentar.body_exited.connect(_on_area_sentar_body_exited)
	saida_onibus.body_entered.connect(_on_saida_onibus_entered)

	protagonista.set_physics_process(false)

	await hud_entrada()

	protagonista.set_physics_process(true)


# =========================
# HUD ENTRADA
# =========================
func hud_entrada() -> void:

	var falas = [
		"Cheio...",
		"Não consigo respirar direito aqui dentro.",
		"Tanta gente. Tantos olhos."
	]

	for f in falas:
		await hud.show_message(f)
		await hud.avancar_dialogo

	await hud.hide_message()


# =========================
# INPUT
# =========================
func _process(_delta):

	if perto_do_banco and not ja_sentou:
		if Input.is_action_just_pressed("interagir"):
			await sentar()


# =========================
# AREA BANCO
# =========================
func _on_area_sentar_body_entered(body):

	if body != protagonista:
		return

	perto_do_banco = true

	if not ja_sentou:
		await hud.show_message("[E] Sentar")


func _on_area_sentar_body_exited(body):

	if body != protagonista:
		return

	perto_do_banco = false
	await hud.hide_message()


# =========================
# SENTAR
# =========================
func sentar() -> void:

	ja_sentou = true
	perto_do_banco = false

	await hud.hide_message()

	protagonista.global_position = posicao_sentada.global_position
	protagonista.sentar_direita()

	protagonista.set_physics_process(false)

	await hud_sentada()

	protagonista.levantar()

	pode_sair = true
	protagonista.set_physics_process(true)


# =========================
# HUD SENTADA
# =========================
func hud_sentada() -> void:

	var falas = []

	if rota == "colorida":
		falas = [
			"Sentei. Olho pro chão.",
			"Meus dedos roçam no papel dentro do meu bolso.",
			"O número dela...",
			"E se eu mandar uma mensagem? O que eu falaria?",
			"...Não. Eu só estragaria tudo.",
			"Ela é tão brilhante. Eu ia acabar apagando isso.",
			"Minha parada. Graças a Deus, minha parada."
		]
	else:
		falas = [
			"Sentei. Foco no chão.",
			"As vozes deles entram na minha cabeça. Rindo, conversando...",
			"Tão fácil pra eles. Tão natural.",
			"Estou tão cansada. Minha cabeça dói.",
			"Minha parada. Graças a Deus, minha parada."
		]

	for f in falas:
		await hud.show_message(f)
		await hud.avancar_dialogo

	await hud.hide_message()


# =========================
# SAÍDA
# =========================
func _on_saida_onibus_entered(body):

	if body != protagonista:
		return

	if not pode_sair:
		return

	if finalizado:
		return

	finalizado = true
	await finalizar_onibus()


func finalizar_onibus():

	protagonista.set_physics_process(false)
	protagonista.set_process_input(false)

	# trava colisão da saída
	saida_onibus.set_deferred("monitoring", false)

	await hud.hide_message()

	# fade total
	await cutscene.fade_out(0.3)

	# cutscene
	
	await cutscene.mostrar_fala("Ar puro. Finalmente.", 1.5)
	await cutscene.mostrar_fala("Meus pés andam no automático até em casa.", 2.0)
	await cutscene.mostrar_fala("Giro a chave. A porta fecha. O mundo fica lá fora.", 2.0)

	if rota == "colorida":
		await cutscene.mostrar_fala("Tiro o papel do bolso. Fico olhando pra ele um bom tempo.", 2.5)
		await cutscene.mostrar_fala("Queria ter coragem... mas hoje eu só quero sumir na minha cama.", 3.0)
	else:
		await cutscene.mostrar_fala("O silêncio do meu quarto dói nos ouvidos.", 2.5)
		await cutscene.mostrar_fala("Sobrevivi a mais um dia... mas a que custo?", 3.0)

	await cutscene.mostrar_fala("Amanhã tem tudo de novo.", 2.0)
	await cutscene.mostrar_fala("Não quero pensar nisso agora.", 2.5)

	# SEGUNDO DIA
	await cutscene.mostrar_fala("SEGUNDO DIA", 2.0)
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout

	# garante flush total antes da troca
	await get_tree().process_frame
	await get_tree().process_frame

	# troca única e final
	if rota == "colorida":
		get_tree().change_scene_to_file("res://scenes/universidade/corredor_colorida_dia2.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/universidade/corredor_quebrada_dia_2.tscn")
