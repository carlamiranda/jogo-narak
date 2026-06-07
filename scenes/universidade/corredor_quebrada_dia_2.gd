extends Node2D

@onready var player = $Protagonista
@onready var menina = $MeninaQuebrada
@onready var hud = $HudGameplayCorredor
@onready var dialogo = $HudDialogo/Control
@onready var overlay = $ColorRect

var encontro := false


func _ready() -> void:
	overlay.visible = true
	overlay.color = Color(0, 0, 0, 0.35)

	dialogo.visible = false

	player.travar()

	menina.set_player(player)

	var area := menina.get_node_or_null("EncontroArea")
	if area == null:
		push_error("EncontroArea não encontrada na MeninaQuebrada")
		return

	area.body_entered.connect(_on_encontro)

	await intro()

	player.liberar()
	menina.iniciar()


# -------------------------
# INTRO
# -------------------------
func intro() -> void:
	await hud.mostrar("O corredor está mais silencioso hoje.")
	await hud.mostrar("Não parece vazio.")
	await hud.mostrar("Parece confortável demais.")
	await hud.mostrar("Como se nada precisasse ser dito.")
	await hud.esconder()


# -------------------------
# ENCONTRO
# -------------------------
func _on_encontro(body: Node) -> void:
	if encontro:
		return

	if body != player:
		return

	encontro = true
	await _iniciar_encontro()


func _iniciar_encontro() -> void:
	player.travar()
	menina.parar()

	await hud_encontro()
	await iniciar_dialogo()


# -------------------------
# HUD
# -------------------------
func hud_encontro() -> void:
	await hud.mostrar("Ela não bloqueia seu caminho.")
	await hud.mostrar("Só está ali.")
	await hud.mostrar("Como se já te conhecesse.")
	await hud.esconder()


# -------------------------
# DIALOGO
# -------------------------
func iniciar_dialogo() -> void:

	dialogo.visible = true

	var falas = [
		{
			"nome": "Menina Quebrada",
			"texto": "Ei...",
			"sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")
		},
		{
			"nome": "Menina Quebrada",
			"texto": "Você deixou isso cair ontem no banheiro.",
			"sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")
		},
		{
			"nome": "Menina Quebrada",
			"texto": "Achei que você ia querer de volta.",
			"sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")
		}
	]

	dialogo.iniciar_dialogo(falas)

	await dialogo.dialogo_finalizado

	await pos_dialogo()


func pos_dialogo() -> void:
	await hud.mostrar("Ela não exige resposta.")
	await hud.mostrar("O silêncio entre vocês não pesa.")
	await hud.mostrar("Ele acolhe.")
	await hud.esconder()

	player.liberar()
