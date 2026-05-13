extends Area2D

@onready var corredor = get_parent()

var ativou = false


func _on_body_entered(body):

	if body.name == "Protagonista" and !ativou:
		ativou = true
		print("PORTA FUNCIONOU")
		corredor.ativar_ui()
