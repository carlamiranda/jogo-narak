extends Node2D

@onready var player = $Protagonista
@onready var menina = $MeninaColorida
@onready var hud = $HudGameplayCorredor
@onready var overlay = $ColorRect

var encontro := false

func _ready() -> void:

	overlay.visible = true
	overlay.color = Color(0, 0, 0, 0.25)

	# 🔒 trava player no HUD
	player.travar()

	# 🔥 IMPORTANTE:
	# NÃO inicia a menina ainda
	menina.set_player(player)

	var area: Area2D = menina.get_node("EncontroArea")
	area.body_entered.connect(_on_encontro)

	await intro()

	# 🔓 libera gameplay
	player.liberar()

	# 🔥 AGORA SIM ela começa perseguir
	menina.iniciar()


func intro() -> void:

	await hud.mostrar(
		"A universidade parece estranhamente cinza hoje."
	)

	await hud.mostrar(
		"Mas tem alguma coisa diferente..."
	)

	await hud.mostrar(
		"Uma luz forte demais atravessa o corredor."
	)

	await hud.mostrar(
		"Quanto mais ela se aproxima..."
	)

	await hud.mostrar(
		"... mais difícil fica respirar."
	)

	await hud.mostrar(
		"Não olha pra ela."
	)

	await hud.mostrar(
		"Só continua andando."
	)

	await hud.esconder()


func _on_encontro(body: Node) -> void:

	if encontro:
		return

	if body != player:
		return

	encontro = true
	_iniciar_encontro()


func _iniciar_encontro() -> void:

	player.travar()

	menina.parar()

	await dialogo()


func dialogo() -> void:

	await hud.mostrar("Ela bloqueia sua passagem.")
	await hud.mostrar("Menina Colorida: Oi...")
	await hud.mostrar("Menina Colorida: Qual o seu nome?")
	await hud.esconder()
