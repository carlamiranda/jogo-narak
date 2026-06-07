extends CharacterBody2D

@export var velocidade: float = 180.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var pode_mover := true


func _physics_process(_delta: float) -> void:

	if not pode_mover:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = dir * velocidade

	move_and_slide()

	_anim(dir)


func _anim(dir: Vector2) -> void:

	if dir == Vector2.ZERO:
		anim.stop()
		return

	if abs(dir.x) > abs(dir.y):

		if dir.x > 0:
			anim.play("walk_right")
		else:
			anim.play("walk_left")

	else:

		if dir.y > 0:
			anim.play("walk_down")
		else:
			anim.play("walk_up")


func sentar_direita() -> void:

	pode_mover = false

	anim.play("seated_right")


func sentar_esquerda() -> void:

	pode_mover = false

	anim.play("seated_left")


func sentar_frente() -> void:

	pode_mover = false

	anim.play("seated_up")


func sentar_costas() -> void:

	pode_mover = false

	anim.play("seated_up")


func levantar() -> void:

	pode_mover = true
