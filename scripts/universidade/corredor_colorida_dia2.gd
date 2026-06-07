extends Node2D

@onready var player = $Protagonista
@onready var menina = $MeninaColorida
@onready var hud = $HudGameplayCorredor
@onready var dialogo = $HudDialogo/Control
@onready var overlay = $ColorRect

var encontro := false


func _ready() -> void:

	overlay.visible = true
	overlay.color = Color(0, 0, 0, 0.25)

	dialogo.visible = false

	player.travar()

	menina.set_player(player)

	var area: Area2D = menina.get_node("EncontroArea")
	area.body_entered.connect(_on_encontro)

	await intro()

	player.liberar()
	menina.iniciar()


func intro() -> void:

	await hud.mostrar("A universidade parece estranhamente cinza hoje.")
	await hud.mostrar("Mas tem algo queimando no fundo do corredor.")
	await hud.mostrar("Uma luz forte demais atravessa o espaço.")
	await hud.mostrar("Quanto mais ela se aproxima, mais difícil fica respirar.")
	await hud.mostrar("Não olha diretamente.")
	await hud.mostrar("Só continua andando.")

	await hud.esconder()


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


func hud_encontro() -> void:

	await hud.mostrar("Ela bloqueia sua passagem.")
	await hud.mostrar("A luz dela invade o corredor.")
	await hud.mostrar("Você não consegue desviar o olhar.")
	await hud.esconder()


func iniciar_dialogo() -> void:

	dialogo.visible = true

	var falas = [
		{
			"nome": "Menina Colorida",
			"texto": "Oi...",
			"sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")
		},
		{
			"nome": "Menina Colorida",
			"texto": "Qual o seu nome?",
			"sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")
		},
		{
			"nome": "Menina Colorida",
			"texto": "Você sempre foge assim?",
			"sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")
		}
	]

	dialogo.iniciar_dialogo(falas)

	await dialogo.dialogo_finalizado

	await pos_dialogo()


func pos_dialogo() -> void:

	await hud.mostrar("Ela não sai da sua frente.")
	await hud.mostrar("Algo dentro de você começa a se mover.")
	await hud.mostrar("O corredor parece menos pesado agora.")

	await hud.esconder()

	player.liberar()
