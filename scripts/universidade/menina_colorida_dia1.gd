extends CharacterBody2D

@export var velocidade := 140.0
@export var aceleracao := 500.0
@export var distancia_parada := 18.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var target: Node2D = null
var ativa := false


func set_player(player: Node2D) -> void:
	# pega o FollowPoint da protagonista
	if player.has_node("FollowPoint"):
		target = player.get_node("FollowPoint")
	else:
		push_error("FollowPoint não encontrado na Protagonista!")


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

	var to_target := target.global_position - global_position
	var dist := to_target.length()

	# ✅ PARADA REAL (evita tremedeira em cima do player)
	if dist < distancia_parada:
		velocity = velocity.move_toward(Vector2.ZERO, aceleracao * delta)
		move_and_slide()
		_atualizar_anim()
		return

	# direção normalizada segura
	var dir := to_target / dist
	var desired_velocity := dir * velocidade

	# movimento suave
	velocity = velocity.move_toward(desired_velocity, aceleracao * delta)

	move_and_slide()
	_atualizar_anim()


func _atualizar_anim() -> void:
	if velocity.length() < 5:
		anim.stop()
		return

	if abs(velocity.x) > abs(velocity.y):
		anim.play("walk_right" if velocity.x > 0 else "walk_left")
	else:
		anim.play("walk_down" if velocity.y > 0 else "walk_up")
