extends CharacterBody2D

# Configurações do NPC que vão aparecer no Inspector
@export var velocidade := 100.0
@export var pontos_rota: Array[Marker2D] 
@export var fala_da_prota := "Eles estão perto demais..."

# Referência para a animação
@onready var anim = $AnimatedSprite2D

var indice_ponto_atual := 0

func _ready():
	# Conecta o sinal do círculo de ansiedade
	$AreaAnsiedade.body_entered.connect(_on_area_ansiedade_body_entered)


func _physics_process(_delta):
	# Se a lista de pontos estiver vazia, ele fica parado
	if pontos_rota.is_empty() or pontos_rota[0] == null:
		anim.play("idle")
		return

	# Pega a posição do ponto atual
	var destino = pontos_rota[indice_ponto_atual].global_position
	var direcao = (destino - global_position).normalized()

	# Aplica o movimento
	velocity = direcao * velocidade
	move_and_slide()

	# Sistema de Animação
	if velocity == Vector2.ZERO:
		anim.play("idle")
	elif abs(direcao.x) > abs(direcao.y):
		if direcao.x > 0:
			anim.play("walk_right")
		else:
			anim.play("walk_left")
	else:
		if direcao.y > 0:
			anim.play("walk_down")
		else:
			anim.play("walk_up")

	# Checa se chegou no ponto (com uma margem de 10 pixels pra não ficar tremendo)
	if global_position.distance_to(destino) < 10.0:
		indice_ponto_atual += 1 
		
		# Faz o loop: se acabou os pontos, volta pro primeiro
		if indice_ponto_atual >= pontos_rota.size():
			indice_ponto_atual = 0


# Função que dispara quando o raio de ansiedade encosta em algo
func _on_area_ansiedade_body_entered(body):
	
	# Só faz efeito se for a protagonista
	if body.name == "Protagonista":
		
		# Acha o HUD na cena principal para soltar o pensamento
		var hud = get_tree().current_scene.get_node_or_null("HudCorredor")
		
		if hud:
			hud.show_message(fala_da_prota)

		# --- NOVA PARTE: Arranca um coração da HUD de vida! ---
		var hud_vida = get_tree().current_scene.get_node_or_null("HudPrincipal")
		if hud_vida:
			hud_vida.tomar_dano()
		# ------------------------------------------------------
