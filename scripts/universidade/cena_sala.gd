extends Node2D

@onready var protagonista = $Protagonista
@onready var menina_colorida = $MeninaColorida
@onready var hud = $HudSala
@onready var dialogo = $HudDialogo/Control
@onready var area_sentar = $AreaSentar
@onready var marker_ana = $MarkerAna
@onready var marker_corredor = $SaidaCorredor

enum EstadoCena { EXPLORANDO, ENCONTRO, FINAL }
var estado := EstadoCena.EXPLORANDO

var perto_da_carteira := false
var sentou := false


func _ready() -> void:

	GameState.definir_rota("colorida")

	menina_colorida.set_ativo(false)
	dialogo.visible = false

	area_sentar.body_entered.connect(_on_area_sentar_body_entered)
	area_sentar.body_exited.connect(_on_area_sentar_body_exited)

	dialogo.dialogo_finalizado.connect(_on_dialogo_finalizado)

	marker_corredor.body_entered.connect(_on_saida_corredor_body_entered)

	protagonista.set_physics_process(false)

	await hud_exploracao()

	protagonista.set_physics_process(true)


# =========================
# HUD EXPLORAÇÃO (CERCAMENTO)
# =========================
func hud_exploracao() -> void:

	await hud.show_message("preciso encontrar um lugar pra sentar sem chamar atenção.")
	await hud.avancar_dialogo

	await hud.show_message("AÇÃO: sente-se quando surgir a opção [E].")
	await hud.avancar_dialogo

	await hud.hide_message()


# =========================
# LOOP
# =========================
func _process(_delta):

	if estado != EstadoCena.EXPLORANDO:
		return

	if perto_da_carteira and not sentou:
		if Input.is_action_just_pressed("interagir"):
			await sentar()


# =========================
# ÁREA SENTAR
# =========================
func _on_area_sentar_body_entered(body):

	if body != protagonista:
		return

	perto_da_carteira = true

	if not sentou:
		await hud.show_message("[E] sentar")
	

func _on_area_sentar_body_exited(body):

	if body != protagonista:
		return

	perto_da_carteira = false
	await hud.hide_message()


# =========================
# SENTAR → CERCAMENTO
# =========================
func sentar() -> void:

	estado = EstadoCena.ENCONTRO
	sentou = true

	await hud.hide_message()

	protagonista.sentar_frente()
	protagonista.set_physics_process(false)

	menina_colorida.set_ativo(true)
	menina_colorida.set_alvo(marker_ana.global_position)

	await hud_cercamento()

	await esperar_chegada()

	# As falas do bilhete foram movidas direto para o diálogo forçado
	iniciar_dialogo_forcado()


# =========================
# HUD CERCAMENTO (PRESSÃO)
# =========================
func hud_cercamento() -> void:

	await hud.show_message("...")
	await hud.avancar_dialogo

	await hud.hide_message()


# =========================
# CHEGADA
# =========================
func esperar_chegada() -> void:

	while menina_colorida.global_position.distance_to(marker_ana.global_position) > 10:
		await get_tree().process_frame


# =========================
# DIÁLOGO (NATURAL / NÃO ARROGANTE)
# =========================
func iniciar_dialogo_forcado() -> void:

	dialogo.visible = true

	var falas = [
		# Falas movidas da função sentar()
		{"nome":"Menina Colorida", "texto":"Oi… desculpa te parar assim.", "sprite":preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")},
		{"nome":"Protagonista", "texto":"...", "sprite":preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")},
		{"nome":"Menina Colorida", "texto":"Eu só… sempre te vejo tentando ficar longe.", "sprite":preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")},
		{"nome":"Menina Colorida", "texto":"Não é nada ruim. Só achei que você parecia sozinha.. se quiser uma amiga estou aqui.", "sprite":preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")},
		{"nome":"Menina Colorida", "texto":"Esse é o meu whatsapp.", "sprite":preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")},
		{"nome":"Menina Colorida", "texto":"“8599993-5662” ... me manda um Oi quando tiver tempo", "sprite":preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")},
	]

	dialogo.iniciar_dialogo(falas)


# =========================
# FINAL
# =========================
func _on_dialogo_finalizado():

	estado = EstadoCena.FINAL

	protagonista.levantar()
	protagonista.set_physics_process(true)

	await hud_final_aula()


func hud_final_aula() -> void:

	await hud.show_message("Estranho...")
	await hud.avancar_dialogo
	
	await hud.show_message("Mas pelo menos a aula terminou.")
	await hud.avancar_dialogo

	await hud.show_message("Finalmente posso sair dessa sala.")
	await hud.avancar_dialogo

	await hud.hide_message()


# =========================
# SAÍDA
# =========================
func _on_saida_corredor_body_entered(body):

	if body != protagonista:
		return

	if estado != EstadoCena.FINAL:
		return

	get_tree().change_scene_to_file("res://scenes/universidade/corredor_colorida_dia1.tscn")
