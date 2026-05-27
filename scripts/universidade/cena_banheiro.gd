extends Node2D

@onready var protagonista = $Protagonista
@onready var espelho = $EspelhoBanheiro
@onready var hud = $HudBanheiro
@onready var area_box = $AreaBox
@onready var porta_fechada = $AreaBox/PortaFechada

var chegou_espelho := false
var cutscene_rodando := false
var investigando := false
var trancada_no_box := false


func _ready():

	# trava movimento no começo
	protagonista.set_physics_process(false)
	protagonista.velocity = Vector2.ZERO

	area_box.body_entered.connect(_on_area_box_body_entered)

	# movimento automático até o espelho
	await mover_ate_espelho()


func mover_ate_espelho() -> void:

	while protagonista.global_position.distance_to(espelho.global_position) > 20:

		var dir = (
			espelho.global_position - protagonista.global_position
		).normalized()

		protagonista.velocity = dir * 120

		protagonista.move_and_slide()

		if abs(dir.x) > abs(dir.y):

			if dir.x > 0:
				protagonista.anim.play("walk_right")
			else:
				protagonista.anim.play("walk_left")

		else:

			if dir.y > 0:
				protagonista.anim.play("walk_down")
			else:
				protagonista.anim.play("walk_up")

		await get_tree().physics_frame

	protagonista.velocity = Vector2.ZERO
	protagonista.anim.stop()

	await _cutscene_espelho()


func _cutscene_espelho():

	var falas = [
		"Água fria. Eu só preciso de água fria no rosto.",
		"Cinco coisas... Cinco coisas...",
		"Preciso focar em cinco coisas.",
		"O espelho, a pia, a luz...",
		"O zumbido dessa lâmpada está me deixando pior...",
		"CALMA!",
		"Você está segura aqui.",
		"Ninguém vai entrar."
	]

	for fala in falas:
		hud.show_message(fala)
		await hud.avancar_dialogo

	await hud.hide_message()

	# libera movimento
	protagonista.set_physics_process(true)

	investigando = true
	cutscene_rodando = false


func _on_area_box_body_entered(body):

	if body == protagonista and investigando and not trancada_no_box:

		trancada_no_box = true

		fechar_porta_do_box()


func fechar_porta_do_box():

	porta_fechada.visible = true

	protagonista.get_node("AnimatedSprite2D").visible = false

	protagonista.velocity = Vector2.ZERO

	protagonista.set_physics_process(false)

	await get_tree().create_timer(1.0).timeout

	await hud.show_message("Pronto... ninguém vai me ver aqui.")
	await hud.avancar_dialogo

	await hud.show_message("É só esperar passar.")
	await hud.avancar_dialogo

	await hud.hide_message()
