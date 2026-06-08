extends Node2D

@onready var player = $Protagonista
@onready var menina = $MeninaColorida
@onready var hud = $HudGameplayCorredor
@onready var dialogo = $HudDialogo/Control
@onready var overlay = $ColorRect
@onready var cutscene = $CutsceneUI

var encontro := false


func _ready() -> void:
	overlay.visible = true
	overlay.color = Color(0, 0, 0, 0.35)

	dialogo.visible = false

	player.travar()

	var area := menina.get_node_or_null("EncontroArea")
	if area:
		area.body_entered.connect(_on_encontro)

	await intro()

	player.liberar()


func intro() -> void:
	await hud.mostrar("Depois de tantas semanas juntas, algo começou a mudar.")
	await hud.mostrar("O mundo já não parecia tão vazio quanto antes.")
	await hud.mostrar("Mas o medo ainda estava lá.")
	await hud.esconder()


func _on_encontro(body: Node) -> void:
	if encontro or body != player:
		return

	encontro = true
	await iniciar_encontro()


func iniciar_encontro() -> void:
	player.travar()
	await iniciar_dialogo()


func iniciar_dialogo() -> void:
	dialogo.visible = true

	var falas = [
		{
			"nome": "Menina Colorida",
			"texto": "Ei... você anda sumida de novo.",
			"sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")
		},
		{
			"nome": "Protagonista",
			"texto": "Eu sei. Só está ficando difícil lidar com tudo.",
			"sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")
		},
		{
			"nome": "Menina Colorida",
			"texto": "Você não precisa lidar com tudo sozinha.",
			"sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")
		},
		{
			"nome": "Protagonista",
			"texto": "Mas eu tenho medo.",
			"sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")
		},
		{
			"nome": "Menina Colorida",
			"texto": "Ter medo não significa que você precisa parar.",
			"sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")
		},
		{
			"nome": "Menina Colorida",
			"texto": "Já pensou em procurar ajuda profissional?",
			"sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")
		},
		{
			"nome": "Protagonista",
			"texto": "Terapia?",
			"sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")
		},
		{
			"nome": "Menina Colorida",
			"texto": "Sim. Pedir ajuda não é fraqueza.",
			"sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")
		},
		{
			"nome": "Menina Colorida",
			"texto": "Às vezes é a coisa mais corajosa que alguém pode fazer.",
			"sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")
		},
		{
			"nome": "Protagonista",
			"texto": "Eu estou cansada de fugir.",
			"sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")
		},
		{
			"nome": "Protagonista",
			"texto": "Talvez esteja na hora de tentar viver de verdade.",
			"sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")
		},
		{
			"nome": "Menina Colorida",
			"texto": "Então vamos dar o primeiro passo.",
			"sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")
		}
	]

	dialogo.iniciar_dialogo(falas)
	await dialogo.dialogo_finalizado

	GameState.alterar_estado(20, -20, 30, 25, -30)

	await final_aceitacao()


func final_aceitacao() -> void:
	await cutscene.play_fade_out(1.0)

	await cutscene.show_text("O medo não desapareceu naquele dia.", 3.5)
	await cutscene.show_text("Mas pela primeira vez, eu parei de correr dele.", 3.5)

	await cutscene.show_text("Nos dias seguintes, ela continuou insistindo.", 3.5)
	await cutscene.show_text("Me chamou para almoçar.", 3.0)
	await cutscene.show_text("Me fez responder mensagens.", 3.0)
	await cutscene.show_text("Me lembrou que eu existia.", 3.5)

	await cutscene.show_text("E um dia, me acompanhou até a terapia.", 4.0)

	await cutscene.show_text("Foi difícil.", 2.5)
	await cutscene.show_text("Foi assustador.", 2.5)
	await cutscene.show_text("Mas cada pequeno passo me aproximava da luz.", 4.0)

	await cutscene.show_text("Eu descobri que melhorar não significa deixar de sentir medo.", 4.5)
	await cutscene.show_text("Significa continuar caminhando apesar dele.", 4.0)

	await cutscene.show_text("Nem todos os dias são fáceis.", 3.0)
	await cutscene.show_text("Mas agora eu sei que não preciso enfrentá-los sozinha.", 4.0)

	await get_tree().create_timer(1.0).timeout

	await cutscene.show_text("SE VOCÊ ESTÁ SOFRENDO,", 3.5)
	await cutscene.show_text("PROCURE AJUDA.", 3.5)
	await cutscene.show_text("VOCÊ NÃO ESTÁ SOZINHO.", 5.0)

	await get_tree().create_timer(1.5).timeout

	await cutscene.show_text("FIM.", 4.0)

	await get_tree().create_timer(1.0).timeout

	get_tree().change_scene_to_file("res://scenes/menus/menu_principal.tscn")
