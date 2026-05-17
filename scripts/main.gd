extends Control

@onready var label_situacao = $CanvasLayer/Panel/VBoxContainer/LabelSituacao

@onready var botao_a = $CanvasLayer/Panel/VBoxContainer/ButtonOpcaoA
@onready var botao_b = $CanvasLayer/Panel/VBoxContainer/ButtonOpcaoB

# LABELS DENTRO DOS TEXTUREBUTTONS
@onready var texto_botao_a = $CanvasLayer/Panel/VBoxContainer/ButtonOpcaoA/Label
@onready var texto_botao_b = $CanvasLayer/Panel/VBoxContainer/ButtonOpcaoB/Label

@onready var protagonista = $Protagonista
@onready var destino_banheiro = $DestinoBanheiro


func _ready():
	mostrar_escolha_inicial()


func mostrar_escolha_inicial():

	label_situacao.text = "Você chega na universidade. O que fazer?"

	texto_botao_a.text = "Enfrentar sala"
	texto_botao_b.text = "Ir ao banheiro"

	botao_a.visible = true
	botao_b.visible = true

	_limpar()

	botao_a.pressed.connect(escolher_sala)
	botao_b.pressed.connect(escolher_banheiro)


func escolher_sala():

	label_situacao.text = "Você entrou na sala..."

	texto_botao_a.text = "Finalizar"

	botao_b.visible = false

	_limpar()

	botao_a.pressed.connect(reiniciar)


func escolher_banheiro():

	label_situacao.text = "Você vai até a porta..."

	texto_botao_a.text = "Ir"

	botao_b.visible = false

	_limpar()

	botao_a.pressed.connect(ir_banheiro)


func ir_banheiro():

	botao_a.visible = false

	protagonista.andando_automatico = true
	protagonista.destino = destino_banheiro.global_position

	protagonista.trocar_cena = true

	protagonista.cena_destino = "res://scenes/CenaBanheiro.tscn"


func reiniciar():
	get_tree().change_scene_to_file("res://CenaInicial.tscn")


func _limpar():

	for c in botao_a.pressed.get_connections():
		botao_a.pressed.disconnect(c.callable)

	for c in botao_b.pressed.get_connections():
		botao_b.pressed.disconnect(c.callable)
