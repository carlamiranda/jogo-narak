extends Node

# Controla os efeitos visuais baseados nas emoções
@export var camera: Camera2D
@export var canvas_modulate: CanvasModulate
@export var color_rect_ansiedade: ColorRect

var camera_posicao_inicial: Vector2
var intensidade_tremor: float = 0.0


#salva a posição inicial da câmera
func _ready() -> void:
	if camera != null:
		camera_posicao_inicial = camera.position


#atualiza os efeitos a cada frame
func _process(delta: float) -> void:
	atualizar_cor_geral()
	atualizar_camada_ansiedade()
	atualizar_tremor()


#muda a cor geral da cena
func atualizar_cor_geral() -> void:
	if canvas_modulate == null:
		return

	var confianca_normalizada: float = GameState.confianca / 100.0
	var isolamento_normalizado: float = GameState.isolamento / 100.0

	if GameState.rota_atual == "colorida":
		#quanto mais confiança, mais clara fica a cena
		canvas_modulate.color = Color(
			0.75 + confianca_normalizada * 0.25,
			0.75 + confianca_normalizada * 0.25,
			0.75 + confianca_normalizada * 0.25
		)

	elif GameState.rota_atual == "espelho":
		#quanto mais isolamento, mais fria e escura fica a cena
		canvas_modulate.color = Color(
			0.75 - isolamento_normalizado * 0.35,
			0.75 - isolamento_normalizado * 0.35,
			0.85 - isolamento_normalizado * 0.45
		)

	else:
		#visual inicial mais cinza
		canvas_modulate.color = Color(0.75, 0.75, 0.75)


#cria uma camada escura/transparente baseada na ansiedade
func atualizar_camada_ansiedade() -> void:
	if color_rect_ansiedade == null:
		return

	var ansiedade_normalizada: float = GameState.ansiedade / 100.0
	var isolamento_normalizado: float = GameState.isolamento / 100.0

	var alpha: float = ansiedade_normalizada * 0.25 + isolamento_normalizado * 0.20
	alpha = clamp(alpha, 0.0, 0.55)

	color_rect_ansiedade.color = Color(0, 0, 0, alpha)


#faz a câmera tremer quando a ansiedade está alta
func atualizar_tremor() -> void:
	if camera == null:
		return

	var ansiedade_normalizada: float = GameState.ansiedade / 100.0

	if GameState.ansiedade < 60:
		camera.position = camera_posicao_inicial
		return

	intensidade_tremor = (ansiedade_normalizada - 0.6) * 20.0

	var deslocamento_x: float = randf_range(-intensidade_tremor, intensidade_tremor)
	var deslocamento_y: float = randf_range(-intensidade_tremor, intensidade_tremor)

	camera.position = camera_posicao_inicial + Vector2(deslocamento_x, deslocamento_y)
	
