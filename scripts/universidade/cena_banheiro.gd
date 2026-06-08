extends Node2D

@onready var protagonista = $Protagonista
@onready var espelho = $EspelhoBanheiro
@onready var hud = $HudBanheiro
@onready var area_saida = $SaidaOnibus

var investigando := false
var evento_finalizado := false


func _ready() -> void:
	protagonista.set_physics_process(false)
	protagonista.velocity = Vector2.ZERO

	area_saida.body_entered.connect(_on_saida_entered)

	await mover_ate_espelho()


# =========================
# MOVIMENTO AUTOMÁTICO
# =========================
func mover_ate_espelho() -> void:

	while protagonista.global_position.distance_to(espelho.global_position) > 20:

		var dir: Vector2 = (espelho.global_position - protagonista.global_position).normalized()

		protagonista.velocity = dir * 120
		protagonista.move_and_slide()

		await get_tree().physics_frame

	protagonista.velocity = Vector2.ZERO
	protagonista.get_node("AnimatedSprite2D").stop()

	await cutscene_espelho()


# =========================
# CUTSCENE (HUD)
# =========================
func cutscene_espelho() -> void:

	await hud.show_message("Água fria... eu só preciso de água fria no rosto.")
	await hud.avancar_dialogo

	await hud.show_message("Cinco coisas... cinco coisas...")
	await hud.avancar_dialogo

	await hud.show_message("Preciso focar.")
	await hud.avancar_dialogo

	await hud.hide_message()

	# libera controle depois da cutscene
	protagonista.set_physics_process(true)
	investigando = true


# =========================
# SAÍDA PARA ÔNIBUS
# =========================
func _on_saida_entered(body: Node) -> void:

	if body != protagonista:
		return

	if not investigando:
		return

	if evento_finalizado:
		return

	evento_finalizado = true
	await ir_para_onibus()


func ir_para_onibus() -> void:

	protagonista.set_physics_process(false)
	protagonista.velocity = Vector2.ZERO

	await hud.show_message("Você decide sair dali.")
	await hud.avancar_dialogo

	await hud.show_message("O ônibus parece ser o único caminho agora.")
	await hud.avancar_dialogo

	await hud.hide_message()

	get_tree().change_scene_to_file("res://scenes/onibus/PontoDeOnibus.tscn")
