extends CharacterBody2D

var velocidade = 400.0  # Velocidade de cruzeiro
var aceleracao = 200.0  # O quão rápido ele chega na velocidade
var movendo = false     # Variável para a gente controlar pelo "script" da história

func _physics_process(delta):
	# Se a gente quiser que o carro ande (ex: começou a cena)
	if Input.is_action_just_pressed("ui_accept"): # Aperte Espaço para testar
		movendo = true
	
	if movendo:
		# Aumenta a velocidade gradualmente até o limite
		velocity.x = move_toward(velocity.x, velocidade, aceleracao * delta)
	else:
		# Para o carro suavemente
		velocity.x = move_toward(velocity.x, 0, aceleracao * delta)
	
	# Função padrão do Godot para aplicar a velocidade
	move_and_slide()
