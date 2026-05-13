extends CharacterBody2D

@export var velocidade := 500.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var pode_andar := true

var andando_automatico := false
var destino := Vector2.ZERO

var trocar_cena := false
var cena_destino := ""

var ultima_direcao := "right"


# Controla movimento manual, automático e animações
func _physics_process(delta: float) -> void:
	if andando_automatico:
		mover_automaticamente()
		return

	if !pode_andar:
		parar_personagem()
		return

	mover_com_input()


# Movimento automático até um destino
func mover_automaticamente() -> void:
	var distancia = global_position.distance_to(destino)

	if distancia < 15:
		andando_automatico = false
		parar_personagem()

		if trocar_cena and cena_destino != "":
			get_tree().call_deferred("change_scene_to_file", cena_destino)

		return

	var dir = (destino - global_position).normalized()
	velocity = dir * velocidade
	move_and_slide()

	tocar_animacao_movimento(dir)


# Movimento pelo teclado
func mover_com_input() -> void:
	var input_dir = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		input_dir.x += 1

	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1

	if Input.is_action_pressed("move_up"):
		input_dir.y -= 1

	if Input.is_action_pressed("move_down"):
		input_dir.y += 1

	if input_dir != Vector2.ZERO:
		velocity = input_dir.normalized() * velocidade
		move_and_slide()
		tocar_animacao_movimento(input_dir)
	else:
		parar_personagem()


# Escolhe animação de andar
func tocar_animacao_movimento(direcao: Vector2) -> void:
	if anim == null:
		return

	if abs(direcao.x) >= abs(direcao.y):
		if direcao.x >= 0:
			ultima_direcao = "right"

			if anim.sprite_frames.has_animation("walk_right"):
				anim.play("walk_right")
		else:
			ultima_direcao = "left"

			if anim.sprite_frames.has_animation("walk_left"):
				anim.play("walk_left")
	else:
		if ultima_direcao == "right":
			if anim.sprite_frames.has_animation("walk_right"):
				anim.play("walk_right")
		else:
			if anim.sprite_frames.has_animation("walk_left"):
				anim.play("walk_left")


# Para a personagem e toca animação parada
func parar_personagem() -> void:
	velocity = Vector2.ZERO
	move_and_slide()

	if anim == null:
		return

	if ultima_direcao == "right":
		if anim.sprite_frames.has_animation("idle_right"):
			anim.play("idle_right")
	else:
		if anim.sprite_frames.has_animation("idle_left"):
			anim.play("idle_left")
