extends Node2D

# Personagens
@onready var protagonista = $Protagonista
@onready var menina_colorida = $MeninaColorida

# HUD
@onready var hud = $HudSala

# Câmera
@onready var camera = $Protagonista/Camera2D

# 🔥 MARKER/AREA DE SAÍDA
@onready var marker_corredor = $SaidaCorredor

# Estado da cena
var cutscene_inicial_rodando := false


func _ready() -> void:

	# Garante rota
	GameState.definir_rota("colorida")

	# Ajuste emocional
	GameState.alterar_estado(10, -10, 15, 20, 0)

	print("Entrou na CenaSala")

	# 🔒 trava protagonista
	if protagonista != null:
		protagonista.set_physics_process(false)
		protagonista.velocity = Vector2.ZERO

	# 🔥 conecta área de troca de cena
	marker_corredor.body_entered.connect(_on_marker_corredor_body_entered)

	await iniciar_cutscene_sala()


# ================= CUTSCENE =================
func iniciar_cutscene_sala() -> void:

	cutscene_inicial_rodando = true

	await iniciar_hud_sala()

	finalizar_cutscene_inicial()


# ================= HUD =================
func iniciar_hud_sala() -> void:

	if hud == null:
		print("HudSala não encontrado")
		return

	await hud.show_message("A sala parece maior do que deveria.")
	await hud.avancar_dialogo

	await hud.show_message("As conversas se misturam em um ruído difícil de ignorar.")
	await hud.avancar_dialogo

	await hud.show_message("Ela tenta respirar fundo e não chamar atenção.")
	await hud.avancar_dialogo

	await hud.show_message("No meio da sala, uma presença colorida chama seu olhar.")
	await hud.avancar_dialogo

	await hud.hide_message()


# ================= FINALIZA CUTSCENE =================
func finalizar_cutscene_inicial() -> void:

	cutscene_inicial_rodando = false

	# 🔓 libera protagonista
	if protagonista != null:
		protagonista.set_physics_process(true)

	print("Cutscene inicial da sala finalizada")


# ================= TROCA DE CENA =================
func _on_marker_corredor_body_entered(body):

	if body != protagonista:
		return

	get_tree().change_scene_to_file("res://scenes/universidade/corredor_colorida.tscn")
