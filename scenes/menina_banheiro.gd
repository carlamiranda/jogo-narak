extends CharacterBody2D

@export var velocidade = 110

var movendo = false
var destino = Vector2.ZERO

@onready var anim = $AnimatedSprite2D


func _physics_process(delta):

	if movendo:

		var direcao = (destino - global_position).normalized()

		velocity = direcao * velocidade

		move_and_slide()

		if direcao.x > 0:

			anim.play("walk_right")

		elif direcao.x < 0:

			anim.play("walk_left")

		if global_position.distance_to(destino) < 10:

			movendo = false

			velocity = Vector2.ZERO

			anim.stop()
