extends Node2D

# Personagens
@onready var protagonista = $Protagonista
@onready var menina_colorida = $MeninaColorida

# HUD
@onready var hud = $HudSala
# Câmera
@onready var camera = $Protagonista/Camera2D

# Estado da cena
var cutscene_inicial_rodando := false


func _ready() -> void:
	# Garante que estamos na rota da sala/colorida
	GameState.definir_rota("colorida")

	# Pequeno ajuste emocional ao entrar na sala
	GameState.alterar_estado(10, -10, 15, 20, 0)

	print("Entrou na CenaSala")
	print("Rota: ", GameState.rota_atual)
	print("Ansiedade: ", GameState.ansiedade)
	print("Isolamento: ", GameState.isolamento)
	print("Confiança: ", GameState.confianca)
	print("Vínculo Colorida: ", GameState.vinculo_colorida)

	# Bloqueia a protagonista durante a introdução
	if protagonista != null:
		protagonista.pode_andar = false
		protagonista.velocity = Vector2.ZERO

	await iniciar_cutscene_sala()


# Introdução da sala
func iniciar_cutscene_sala() -> void:
	cutscene_inicial_rodando = true

	await iniciar_hud_sala()

	finalizar_cutscene_inicial()


# Falas do HUD da sala
func iniciar_hud_sala() -> void:
	if hud == null:
		print("HudSala não encontrado")
		return

	await hud.show_message("A sala parece maior do que deveria.", 2.5)
	await hud.show_message("As conversas se misturam em um ruído difícil de ignorar.", 3.5)
	await hud.show_message("Ela tenta respirar fundo e não chamar atenção.", 3.0)
	await hud.show_message("No meio da sala, uma presença colorida chama seu olhar.", 3.5)


# Libera a personagem depois da introdução
func finalizar_cutscene_inicial() -> void:
	cutscene_inicial_rodando = false

	if protagonista != null:
		protagonista.pode_andar = true

	print("Cutscene inicial da sala finalizada")
