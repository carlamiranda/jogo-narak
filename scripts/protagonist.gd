extends CharacterBody2D

@export var speed = 250

@onready var anim = $AnimatedSprite2D

var pode_andar = true
var andando_automatico = false
var destino = Vector2.ZERO

var trocar_cena = false
var cena_destino = ""


func _physics_process(delta):

	# Movimento automático
	if andando_automatico:

		var direcao = (destino - global_position).normalized()
		velocity = direcao * speed
		move_and_slide()

		# animação
		if abs(direcao.x) > abs(direcao.y):

			if direcao.x > 0:
				anim.play("walk_right")
			else:
				anim.play("walk_left")

		else:

			if direcao.y > 0:
				anim.play("walk_down")
			else:
				anim.play("walk_up")

		# chegada segura
		if global_position.distance_to(destino) <= 12:

			andando_automatico = false
			velocity = Vector2.ZERO

			anim.play("walk_up")

			await get_tree().create_timer(0.15).timeout

			if trocar_cena:
				get_tree().change_scene_to_file(cena_destino)

		return


	# Bloqueio
	if not pode_andar:
		velocity = Vector2.ZERO
		anim.stop()
		return

	# Movimento normal
	var input_dir = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1


	var direction = Vector2.ZERO

	if abs(input_dir.x) > abs(input_dir.y):
		direction = Vector2(input_dir.x, 0)
	elif abs(input_dir.y) > 0:
		direction = Vector2(0, input_dir.y)

	velocity = direction * speed
	move_and_slide()

	if direction == Vector2.ZERO:
		anim.stop()
		return

	if direction.x > 0:
		anim.play("walk_right")
	elif direction.x < 0:
		anim.play("walk_left")
	elif direction.y > 0:
		anim.play("walk_down")
	else:
		anim.play("walk_up")
