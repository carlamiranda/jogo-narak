extends Node2D

@onready var protagonista = $Protagonista
@onready var saida_onibus = $SaidaOnibus

var rota := ""


func _ready() -> void:
	rota = GameState.rota_atual

	saida_onibus.body_entered.connect(_on_saida_onibus_entered)


func _on_saida_onibus_entered(body: Node) -> void:

	if body != protagonista:
		return

	finalizar_onibus()


func finalizar_onibus() -> void:

	if rota == "colorida":
		get_tree().change_scene_to_file(
			"res://scenes/universidade/corredor_colorida_dia2.tscn"
		)
	else:
		get_tree().change_scene_to_file(
			"res://scenes/universidade/corredor_quebrada_dia_2.tscn"
		)
