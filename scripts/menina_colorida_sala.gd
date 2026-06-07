extends CharacterBody2D

const SPEED := 120.0
const ARRIVE_DISTANCE := 10.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var ativo := false
var alvo: Vector2

var fase := 0
var last_dir := Vector2.DOWN


func set_ativo(v: bool) -> void:
	ativo = v

	if not ativo:
		velocity = Vector2.ZERO
		anim.play("idle_left")


func set_alvo(pos: Vector2) -> void:
	alvo = pos
	fase = 0  # reset do caminho


func _physics_process(_delta: float) -> void:

	if not ativo:
		return

	var diff := alvo - global_position

	if diff.length() <= ARRIVE_DISTANCE:
		velocity = Vector2.ZERO
		move_and_slide()
		_play_idle()
		return

	var dir := Vector2.ZERO

	# 🔥 FASE 1: anda no eixo X
	if fase == 0:
		if abs(diff.x) > 5:
			dir = Vector2(sign(diff.x), 0)
		else:
			fase = 1

	# 🔥 FASE 2: anda no eixo Y
	if fase == 1:
		if abs(diff.y) > 5:
			dir = Vector2(0, sign(diff.y))
		else:
			fase = 2

	# fallback
	if dir == Vector2.ZERO:
		dir = diff.normalized()

	velocity = dir * SPEED
	move_and_slide()

	_update_anim(dir)


func _update_anim(dir: Vector2) -> void:

	if dir == Vector2.ZERO:
		return

	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			anim.play("walk_right")
			last_dir = Vector2.RIGHT
		else:
			anim.play("walk_left")
			last_dir = Vector2.LEFT
	else:
		if dir.y > 0:
			anim.play("walk_down")
			last_dir = Vector2.DOWN
		else:
			anim.play("walk_up")
			last_dir = Vector2.UP


func _play_idle() -> void:

	if last_dir == Vector2.RIGHT:
		anim.play("idle_right")
	elif last_dir == Vector2.LEFT:
		anim.play("idle_left")
	elif last_dir == Vector2.DOWN:
		anim.play("idle_down")
	else:
		anim.play("idle_up")
