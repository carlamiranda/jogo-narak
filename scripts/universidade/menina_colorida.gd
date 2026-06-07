extends CharacterBody2D

@export var velocidade := 120.0
@export var aceleracao := 350.0
@export var distancia_minima := 10.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var target: Marker2D = null
var ativa := false


func set_player(p: Node2D) -> void:
	target = p.get_node("FollowPoint")


func iniciar() -> void:
	ativa = true


func parar() -> void:
	ativa = false
	velocity = Vector2.ZERO
	anim.stop()


func _physics_process(delta: float) -> void:

	if not ativa:
		return

	if target == null:
		return

	var to_target: Vector2 = target.global_position - global_position

	var dist := to_target.length()

	# 🔥 evita vibração
	if dist > distancia_minima:

		var dir := to_target.normalized()

		var desired_velocity := dir * velocidade

		velocity = velocity.move_toward(
			desired_velocity,
			aceleracao * delta
		)

	else:
		# desaceleração suave
		velocity = velocity.move_toward(
			Vector2.ZERO,
			aceleracao * delta
		)

	move_and_slide()

	_atualizar_anim(velocity)


func _atualizar_anim(v: Vector2) -> void:

	if v.length() < 5:
		anim.stop()
		return

	if abs(v.x) > abs(v.y):
		anim.play("walk_right" if v.x > 0 else "walk_left")
	else:
		anim.play("walk_down" if v.y > 0 else "walk_up")
