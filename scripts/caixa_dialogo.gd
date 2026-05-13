extends Control

@onready var retrato = $Panel/retrato
@onready var nome_label = $Panel/nome
@onready var texto_label = $Panel/texto
@onready var timer = $Panel/LetterTimer

var falas = []
var fala_atual = 0

func _ready():
	timer.timeout.connect(_on_timer_timeout)

func iniciar_dialogo(lista_fala):
	falas = lista_fala
	fala_atual = 0
	visible = true
	exibir_fala()

func exibir_fala():
	var d = falas[fala_atual]

	nome_label.text = d["nome"]
	texto_label.text = d["texto"]
	retrato.texture = d["sprite"]

	texto_label.visible_ratio = 0
	timer.start()

func _input(event):
	if event.is_action_pressed("ui_accept") or event is InputEventMouseButton:
		if texto_label.visible_ratio < 1:
			texto_label.visible_ratio = 1
		else:
			proxima_fala()

func proxima_fala():
	fala_atual += 1

	if fala_atual < falas.size():
		exibir_fala()
	else:
		visible = false
		get_tree().change_scene_to_file("res://scenes/corredor_universidade.tscn")

func _on_timer_timeout():
	if texto_label.visible_ratio < 1:
		texto_label.visible_ratio += 0.05
	else:
		timer.stop()
