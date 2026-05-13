extends Control

# Arraste o arquivo da sua cena principal do FileSystem para cá para pegar o caminho correto
var cena_jogo = "res://scenes/CenaInicial.tscn"

func _on_btn_novo_jogo_pressed():
	# Muda da tela de menu para a tela do carro e diálogos
	get_tree().change_scene_to_file(cena_jogo)

func _on_btn_sair_pressed():
	# Fecha o jogo
	get_tree().quit()
