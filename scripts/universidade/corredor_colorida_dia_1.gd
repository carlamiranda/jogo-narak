extends Node2D

@onready var player = $Protagonista
@onready var hud = $HudGameplayCorredor
@onready var saida_onibus = $SaidaOnibus

# Novas referências que adicionamos:
@onready var menina = $MeninaColorida
@onready var dialogo = $HudDialogo/Control

var pode_sair := false
var evento_rodando := false
var encontro := false


func _ready() -> void:
	player.travar()

	saida_onibus.body_entered.connect(_on_saida_entered)

	# 1. Avisa a Menina Colorida quem ela deve seguir
	menina.set_player(player)

	# 2. Conecta a área dela para engatilhar o diálogo quando encostar
	var area_encontro: Area2D = menina.get_node("EncontroArea")
	area_encontro.body_entered.connect(_on_encontro)
	
	# 3. Garante que a caixa de diálogo comece invisível
	dialogo.visible = false

	await intro()

	player.liberar()
	pode_sair = true
	
	# 4. Libera a menina para começar a te perseguir pelo corredor
	menina.iniciar()


# =========================
# INTRO
# =========================
func intro() -> void:
	await hud.mostrar("Finalmente casa....")
	await hud.mostrar("preciso pegar o onibus.")
	await hud.esconder()


# =========================
# ENCONTRO COM A MENINA COLORIDA
# =========================
func _on_encontro(body: Node) -> void:
	# Impede de rodar se não for a protagonista ou se outro evento já estiver rodando
	if encontro or body != player or evento_rodando:
		return

	encontro = true
	evento_rodando = true
	await _iniciar_encontro()


func _iniciar_encontro() -> void:
	player.travar() # Trava a protagonista
	menina.parar()  # Trava a menina colorida

	dialogo.visible = true

	# Falas do encontro
	var falas = [
		{
			"nome": "Menina Colorida",
			"texto": "Ei, espera! Você esqueceu isso lá na sala.",
			"sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")
		},
		{
			"nome": "Protagonista",
			"texto": "Ah... obrigada.",
			"sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")
		}
	]

	dialogo.iniciar_dialogo(falas)
	
	# Espera o jogador clicar até o fim do texto
	await dialogo.dialogo_finalizado 

	# Libera o fluxo e a movimentação
	evento_rodando = false
	player.liberar()


# =========================
# ENTRADA NA SAÍDA (PONTO DE ÔNIBUS)
# =========================
func _on_saida_entered(body: Node) -> void:
	if not pode_sair:
		return

	if body != player:
		return

	if evento_rodando:
		return

	evento_rodando = true
	await _ir_para_onibus()


func _ir_para_onibus() -> void:
	player.travar()

	await hud.mostrar("Você respira fundo e segue.")
	await hud.esconder()

	get_tree().change_scene_to_file("res://scenes/onibus/PontoDeOnibus.tscn")
