extends CharacterBody2D

var velocidade = 400.0  # Velocidade de cruzeiro
var aceleracao = 200.0  # O quão rápido ele chega na velocidade
var movendo = false     # Variável para a gente controlar pelo "script" da história

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		movendo = true
	
	if movendo:
		velocity.x = move_toward(velocity.x, velocidade, aceleracao * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, aceleracao * delta)
	
	move_and_slide()
