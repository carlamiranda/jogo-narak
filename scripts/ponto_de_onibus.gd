extends Node2D

@export var tempo_onibus_chegando: float = 2.8
@export var tempo_fade_preto: float = 1.2
@export var offset_onibus_do_jogador: Vector2 = Vector2(140, 0)
@export var cena_destino: String = ""

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
		return

	onibus.z_index = 60
	onibus.scale = Vector2(abs(onibus.scale.x), onibus.scale.y)

	var posicao_final_onibus := _calcular_posicao_final_onibus()

	var tween_onibus := create_tween()
	tween_onibus.set_ease(Tween.EASE_IN_OUT)
	tween_onibus.set_trans(Tween.TRANS_QUAD)
	tween_onibus.tween_property(onibus, "position", posicao_final_onibus, tempo_onibus_chegando)

	await tween_onibus.finished

	await get_tree().create_timer(0.25).timeout
	await _fade_preto()

	if cena_destino != "":
		get_tree().change_scene_to_file(cena_destino)


func _bloquear_protagonista() -> void:
	if protagonista == null:
		return

	if protagonista.has_method("travar"):
		protagonista.travar()
	else:
		protagonista.set_physics_process(false)
		protagonista.velocity = Vector2.ZERO


func _calcular_posicao_final_onibus() -> Vector2:
	var y_onibus := onibus.position.y

	if protagonista != null:
		return Vector2(protagonista.position.x + offset_onibus_do_jogador.x, y_onibus)

	if ponto_parada != null:
		return Vector2(ponto_parada.position.x + offset_onibus_do_jogador.x, y_onibus)

	return onibus.position


func _fade_preto() -> void:
	await Cutscene.play_fade_out(tempo_fade_preto)
