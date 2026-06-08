extends CharacterBody2D

@export var speed: float = 120.0
@export var distancia_minima: float = 20.0
@export var offset_distance: float = 35.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var player: Node2D = null
var pode_andar := false

func set_player(p: Node2D) -> void:
	player = p

func iniciar() -> void:
	pode_andar = true

func parar() -> void:
	pode_andar = false
	velocity = Vector2.ZERO
	anim.stop()

func _physics_process(delta: float) -> void:
	if not pode_andar or player == null:
		return

	# Lógica corrigida para seguir Marker2D ou Player
	var target_pos := Vector2.ZERO
	if player is Marker2D:
		target_pos = player.global_position
	else:
		var player_dir := Vector2.RIGHT
		if player.has_method("get_last_direction"):
			player_dir = player.get_last_direction()
		target_pos = player.global_position - player_dir * offset_distance

	var dir := (target_pos - global_position).normalized()
	var dist := global_position.distance_to(target_pos)

	if dist > distancia_minima:
		velocity = velocity.move_toward(dir * speed, 300 * delta)
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	_anim(velocity)

func _anim(v: Vector2) -> void:
	if v.length() < 5:
		anim.play("idle")
		return

	if abs(v.x) > abs(v.y):
		anim.play("walk_right" if v.x > 0 else "walk_left")
	else:
		anim.play("walk_down" if v.y > 0 else "walk_up")
