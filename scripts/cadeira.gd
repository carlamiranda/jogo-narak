extends Area2D

var jogador_na_area := false

func _on_body_entered(body):
	if body.name == "Protagonista":
		jogador_na_area = true
		print("PODE SENTAR")

func _on_body_exited(body):
	if body.name == "Protagonista":
		jogador_na_area = false
		print("SAIU")
