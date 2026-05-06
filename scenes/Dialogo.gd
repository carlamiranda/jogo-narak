extends CanvasLayer

@onready var texto = $Panel/HBoxContainer/RichTextLabel
@onready var personagem = $Panel/HBoxContainer/VBoxContainer/TextureRect
@onready var nome = $Panel/HBoxContainer/VBoxContainer/Label

var dialogo = []
var index = 0

func _ready():
	print("DIALOGO INICIOU")

func iniciar_dialogo(dados):
	dialogo = dados
	index = 0
	mostrar_fala()

func mostrar_fala():
	if index < dialogo.size():
		var fala = dialogo[index]
		
		texto.text = fala["texto"]
		nome.text = fala["nome"]

		# agora vem direto pronto (sem load)
		personagem.texture = fala["sprite"]
	else:
		queue_free()

func avancar():
	index += 1
	mostrar_fala()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		avancar()
	
	if event is InputEventMouseButton and event.pressed:
		avancar()
