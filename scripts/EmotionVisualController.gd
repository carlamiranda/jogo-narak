extends Node

# Controla efeitos visuais baseados nas emoções

@export var camera: Camera2D
@export var canvas_modulate: CanvasModulate
@export var color_rect_ansiedade: ColorRect

var camera_posicao_inicial: Vector2


# Salva a posição inicial da câmera
func _ready() -> void:
	if camera != null:
		camera_posicao_inicial = camera.position
	else:
		print("Camera não conectada no EmotionVisualController")

	if canvas_modulate == null:
		print("CanvasModulate não conectado no EmotionVisualController")

	if color_rect_ansiedade == null:
		print("ColorRectAnsiedade não conectado no EmotionVisualController")


# Atualiza os efeitos a cada frame
func _process(delta: float) -> void:
	atualizar_cor_geral()
	atualizar_camada_ansiedade()
	atualizar_tremor()


# Muda a cor geral da cena
func atualizar_cor_geral() -> void:
	if canvas_modulate == null:
		return

	var confianca_normalizada: float = GameState.confianca / 100.0
	var isolamento_normalizado: float = GameState.isolamento / 100.0

	if GameState.rota_atual == "colorida":
		canvas_modulate.color = Color(
			1.0,
			0.85 + confianca_normalizada * 0.15,
			0.85 + confianca_normalizada * 0.15
		)

	elif GameState.rota_atual == "espelho":
		canvas_modulate.color = Color(
			0.35,
			0.35,
			0.55
		)

	else:
		canvas_modulate.color = Color(0.75, 0.75, 0.75)


# Escurece a tela com ansiedade e isolamento
func atualizar_camada_ansiedade() -> void:
	if color_rect_ansiedade == null:
		return

	var ansiedade_normalizada: float = GameState.ansiedade / 100.0
	var isolamento_normalizado: float = GameState.isolamento / 100.0

	var alpha: float = ansiedade_normalizada * 0.45 + isolamento_normalizado * 0.35
	alpha = clamp(alpha, 0.0, 0.80)

	color_rect_ansiedade.color = Color(0, 0, 0, alpha)


# Faz a câmera tremer quando ansiedade está alta
func atualizar_tremor() -> void:
	if camera == null:
		return

	if GameState.ansiedade < 60:
		camera.position = camera_posicao_inicial
		return

	var ansiedade_normalizada: float = GameState.ansiedade / 100.0
	var intensidade: float = (ansiedade_normalizada - 0.6) * 80.0

	var deslocamento_x: float = randf_range(-intensidade, intensidade)
	var deslocamento_y: float = randf_range(-intensidade, intensidade)

	camera.position = camera_posicao_inicial + Vector2(deslocamento_x, deslocamento_y)
