extends CharacterBody2D

@export var velocidade := 500.0
@onready var anim = $AnimatedSprite2D

var pode_andar := true

var andando_automatico := false
var destino := Vector2.ZERO

# troca de cena
var trocar_cena := false
var cena_destino := ""

func _physics_process(delta):

	if andando_automatico:

		var distancia = global_position.distance_to(destino)

		if distancia < 15:
			andando_automatico = false
			velocity = Vector2.ZERO
			anim.stop()

			if trocar_cena and cena_destino != "":
				get_tree().call_deferred("change_scene_to_file", cena_destino)

			return

		var dir = (destino - global_position).normalized()
		velocity = dir * velocidade
		move_and_slide()

		if abs(dir.x) > abs(dir.y):
			anim.play("walk_right" if dir.x > 0 else "walk_left")
		else:
			anim.play("walk_right")

		return

	if !pode_andar:
		velocity = Vector2.ZERO
		move_and_slide()
		anim.stop()
		return

	var input_dir = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1

	if input_dir != Vector2.ZERO:
		velocity = input_dir.normalized() * velocidade
		move_and_slide()

		if abs(input_dir.x) > abs(input_dir.y):
			anim.play("walk_right" if input_dir.x > 0 else "walk_left")
		else:
			anim.stop()
	else:
		velocity = Vector2.ZERO
		anim.stop()
