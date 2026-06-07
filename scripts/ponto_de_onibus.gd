extends Node2D

@export var tempo_onibus_chegando: float = 2.8
@export var tempo_fade_preto: float = 1.2
@export var offset_onibus_do_jogador: Vector2 = Vector2(140, 0)

@onready var onibus: Node2D = $Onibus
@onready var protagonista: CharacterBody2D = $Protagonista
@onready var ponto_parada: Node2D = $PontoDeOnibus

var embarque_em_andamento := false


func iniciar_embarque_onibus() -> void:
	if embarque_em_andamento:
		return

	embarque_em_andamento = true

	_bloquear_protagonista()

	if onibus == null:
		push_error("Ônibus não encontrado na cena do ponto.")
		await _fade_preto()
		_trocar_para_onibus_dentro()
		return

	onibus.z_index = 60

	var posicao_final_onibus := _calcular_posicao_final_onibus()

	var tween_onibus := create_tween()
	tween_onibus.set_ease(Tween.EASE_IN_OUT)
	tween_onibus.set_trans(Tween.TRANS_QUAD)
	tween_onibus.tween_property(
		onibus,
		"position",
		posicao_final_onibus,
		tempo_onibus_chegando
	)

	await tween_onibus.finished

	await get_tree().create_timer(0.25).timeout

	await _fade_preto()

	_trocar_para_onibus_dentro()


# =========================
# TRAVA PLAYER
# =========================
func _bloquear_protagonista() -> void:
	if protagonista == null:
		return

	# tenta travar pelo sistema do jogo se existir
	if protagonista.has_method("travar"):
		protagonista.travar()
	elif protagonista.has_method("travar_cutscene"):
		protagonista.travar_cutscene()
	else:
		protagonista.set_physics_process(false)

	protagonista.velocity = Vector2.ZERO


# =========================
# POSIÇÃO DO ÔNIBUS
# =========================
func _calcular_posicao_final_onibus() -> Vector2:
	var y_onibus := onibus.position.y

	if protagonista != null:
		return Vector2(
			protagonista.position.x + offset_onibus_do_jogador.x,
			y_onibus
		)

	if ponto_parada != null:
		return Vector2(
			ponto_parada.position.x + offset_onibus_do_jogador.x,
			y_onibus
		)

	return onibus.position


# =========================
# FADE (CORRETO)
# =========================
func _fade_preto() -> void:
	# aqui NÃO troca cena
	# só espera o fade real do sistema (ou simula)
	if Engine.has_singleton("Cutscene"):
		await Cutscene.play_fade_out(tempo_fade_preto)
	else:
		await get_tree().create_timer(tempo_fade_preto).timeout


# =========================
# TROCA DE CENA (ÚNICA E FINAL)
# =========================
func _trocar_para_onibus_dentro() -> void:
	get_tree().change_scene_to_file("res://scenes/onibus/cena_onibus_dentro.tscn")
