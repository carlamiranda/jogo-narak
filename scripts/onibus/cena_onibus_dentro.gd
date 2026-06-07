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
		"Você entra no ônibus.",
		"O espaço é pequeno.",
		"Desconhecidos ao redor.",
		"O silêncio pesa mais do que o barulho.",
		"Você precisa encontrar um lugar para sentar."
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
			"Você se senta.",
			"O ônibus continua em movimento.",
			"O papel no bolso parece mais pesado.",
			"Você pensa em mandar a primeira mensagem.",
			"Mas hesita.",
			"O medo não é da mensagem.",
			"É de ser vista por alguém que transborda vida.",
			"O ônibus está chegando na sua parada.",
			"Você precisa descer."
		]
	else:
		falas = [
			"Você se senta.",
			"O ônibus continua em movimento.",
			"As vozes ao redor se misturam.",
			"Você tenta focar em alguma coisa.",
			"Mas o cansaço vence antes da ansiedade.",
			"O ônibus está chegando na sua parada.",
			"Você precisa descer."
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
	
	await cutscene.mostrar_fala("O ônibus finalmente para.", 1.5)
	await cutscene.mostrar_fala("Você não percebe o momento em que desce.", 2.0)

	await cutscene.mostrar_fala("As luzes da rua parecem distantes.", 2.0)
	await cutscene.mostrar_fala("Como se o mundo estivesse atrás de um vidro.", 2.0)

	await cutscene.mostrar_fala("A chave gira na porta sem pensamento.", 2.0)
	await cutscene.mostrar_fala("O corpo apenas obedece.", 2.0)

	if rota == "colorida":
		await cutscene.mostrar_fala("O papel no bolso pesa mais do que deveria.", 2.5)
		await cutscene.mostrar_fala("Você pensa na mensagem... mas não consegue mais pensar em nada.", 3.0)
	else:
		await cutscene.mostrar_fala("O silêncio dentro da cabeça é mais alto do que o ônibus inteiro.", 2.5)
		await cutscene.mostrar_fala("Você não lembra exatamente do que sentiu. Só do cansaço.", 3.0)

	await cutscene.mostrar_fala("O mundo continua lá fora.", 2.0)
	await cutscene.mostrar_fala("Mas você não está mais nele por hoje.", 2.5)

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
