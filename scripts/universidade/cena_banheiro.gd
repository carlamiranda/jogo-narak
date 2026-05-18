extends Node2D

# Referências
@onready var protagonista = $Protagonista
@onready var espelho = $EspelhoBanheiro
@onready var hud = $HudBanheiro

# Estado
var chegou_espelho := false
var cutscene_rodando := false
var investigando := false


func _ready():

	protagonista.pode_andar = false
	protagonista.andando_automatico = true
	protagonista.destino = espelho.global_position


func _physics_process(_delta):

	if chegou_espelho or cutscene_rodando:
		return

	if protagonista.global_position.distance_to(espelho.global_position) <= 20:
		chegou_espelho = true
		cutscene_rodando = true

		protagonista.andando_automatico = false
		protagonista.velocity = Vector2.ZERO
		protagonista.anim.play("walk_up")

		call_deferred("_start_cutscene")


func _start_cutscene():
	await _cutscene_espelho()


func _cutscene_espelho():

	protagonista.velocity = Vector2.ZERO

	await hud.show_message("O banheiro está silencioso demais.", 2.0)
	await hud.show_message("Ela encara o espelho.", 2.5)
	await hud.show_message("Seu reflexo parece estranho.", 2.5)

	await hud.show_message("Tem algo aqui...", 2.0)
	await hud.show_message("Talvez seja melhor olhar ao redor.", 3.0)
	await hud.show_message("Especialmente perto das divisórias.", 3.0)

	protagonista.pode_andar = true
	investigando = true
	cutscene_rodando = false
