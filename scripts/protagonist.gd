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

	# Movimento normal com suporte a diagonal e velocidade normalizada
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	velocity = direction * speed
	move_and_slide()

	# Se estiver parada, para a animação
	if direction == Vector2.ZERO:
		anim.stop()
		return

	# Escolhe a animação com base no eixo em que ela está se movendo mais
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			anim.play("walk_right")
		else:
			anim.play("walk_left")
	else:
		if direction.y > 0:
			anim.play("walk_down")
		else:
			anim.play("walk_up")
