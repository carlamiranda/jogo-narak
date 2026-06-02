extends Node2D

@onready var player = $Protagonista
@onready var hud = $HudGameplayCorredor
@onready var saida_onibus = $SaidaOnibus

var pode_sair := false
var evento_rodando := false


func _ready() -> void:
	player.travar()

	saida_onibus.body_entered.connect(_on_saida_entered)

	await intro()

	player.liberar()
	pode_sair = true


# =========================
# INTRO
# =========================
func intro() -> void:
	await hud.mostrar("O corredor está mais vazio hoje.")
	await hud.mostrar("Mas algo parece fora do lugar.")
	await hud.mostrar("Ela sente que precisa sair daqui.")
	await hud.mostrar("O ônibus é a única saída agora.")
	await hud.esconder()


# =========================
# ENTRADA NA SAÍDA
# =========================
func _on_saida_entered(body: Node) -> void:
	if not pode_sair:
		return

	if body != player:
		return

	if evento_rodando:
		return

	evento_rodando = true
	await _ir_para_onibus()

func _ir_para_onibus() -> void:
	player.travar()

	await hud.mostrar("Você para na saída do corredor.")
	await hud.mostrar("O ônibus está logo ali fora.")
	await hud.mostrar("Você respira fundo e segue.")
	await hud.esconder()

	get_tree().change_scene_to_file("res://scenes/onibus/PontoDeOnibus.tscn")
