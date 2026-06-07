extends CharacterBody2D

@export var velocidade: float = 180.0

var pode_andar: bool = true

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	if not pode_andar:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * velocidade

	move_and_slide()
	_anim(dir)


func _anim(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		anim.stop()
		return

	if abs(dir.x) > abs(dir.y):
		anim.play("walk_right" if dir.x > 0 else "walk_left")
	else:
		anim.play("walk_down" if dir.y > 0 else "walk_up")


func travar() -> void:
	pode_andar = false
	velocity = Vector2.ZERO
	anim.stop()


func liberar() -> void:
	pode_andar = true
