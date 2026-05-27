extends Area2D

@onready var label = $Label
@onready var marker = $Marker2D

var player_perto = null


func _ready():
	label.visible = false


func _on_body_entered(body):

	if body.name == "Protagonista":
		player_perto = body
		label.visible = true


func _on_body_exited(body):

	if body.name == "Protagonista":
		player_perto = null
		label.visible = false


func _process(delta):

	if player_perto != null and Input.is_action_just_pressed("interagir"):

		player_perto.global_position = marker.global_position

		player_perto.pode_andar = false

		label.visible = false

		print("Sentou na cadeira")
