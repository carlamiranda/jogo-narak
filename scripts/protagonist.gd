extends CharacterBody2D

@export var velocidade: float = 180.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:

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
