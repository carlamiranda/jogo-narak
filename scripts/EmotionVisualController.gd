extends Node

# Controla efeitos visuais baseados nas emoções

@export var camera: Camera2D
@export var canvas_modulate: CanvasModulate
@export var color_rect_ansiedade: ColorRect

var camera_posicao_inicial: Vector2
var intensidade_da_crise: float = 1.0 # --- NOVA VARIÁVEL ---


# Salva a posição inicial da câmera
func _ready() -> void:
	if camera != null:
		camera.offset = Vector2.ZERO
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
	atualizar_tremor(delta) # --- Passamos o tempo (delta) pra cá ---


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


# --- FUNÇÃO TOTALMENTE REESCRITA ---
func atualizar_tremor(delta: float) -> void:
	if camera == null:
		return

	var ansiedade_normalizada: float = GameState.ansiedade / 100.0
	var isolamento_normalizado: float = GameState.isolamento / 100.0

	var tensao: float = max(ansiedade_normalizada, isolamento_normalizado)

	if tensao < 0.6:
		camera.offset = Vector2.ZERO
		intensidade_da_crise = 1.0 # Zera a crise se a ansiedade baixar
		return

	var deslocamento_x: float = 0.0
	var deslocamento_y: float = 0.0

	if tensao >= 0.99:
		# GAME OVER (CRISE DE ANSIEDADE): Crescimento agressivo e violento
		intensidade_da_crise += delta * 15.0 
		deslocamento_x = randf_range(-intensidade_da_crise, intensidade_da_crise)
		deslocamento_y = randf_range(-intensidade_da_crise, intensidade_da_crise)
	else:
		# GAMEPLAY NORMAL: Efeito de "tontura" beeem fraco
		intensidade_da_crise = 1.0 
		
		# Força de 0.3 (quase imperceptível) até 0.8 pixels
		var forca: float = 0.3 if tensao < 0.8 else 0.8
		
		# O SEGREDO: Atualiza a posição apenas a cada 4 frames.
		# Isso faz a tremedeira ficar lenta, parecendo o batimento cardíaco ou respiração ofegante.
		if Engine.get_frames_drawn() % 4 == 0:
			deslocamento_x = randf_range(-forca, forca)
			deslocamento_y = randf_range(-forca, forca)
		else:
			return # Nos outros frames, não faz nada (mantém a câmera onde já está)

	camera.offset = Vector2(deslocamento_x, deslocamento_y)
