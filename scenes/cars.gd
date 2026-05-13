extends CharacterBody2D

var velocidade = 400.0  
var aceleracao = 200.0  
var movendo = false     

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"): # Aperte Espaço para testar
		movendo = true
	
	if movendo:
		velocity.x = move_toward(velocity.x, velocidade, aceleracao * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, aceleracao * delta)
	
	move_and_slide()
