extends Control

signal dialogo_finalizado

@onready var texto_label = $PanelContainer/MarginContainer/HBoxContainer/texto
@onready var retrato = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/retrato
@onready var nome_label = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/nome

var falas: Array = []
var fala_atual := 0

var escrevendo := false
var aguardando := false


func _ready():
	visible = false


func iniciar_dialogo(lista_fala: Array) -> void:
	if lista_fala.is_empty():
		return

	falas = lista_fala
	fala_atual = 0
	visible = true

	_exibir_fala()


func _exibir_fala() -> void:
	aguardando = false
	escrevendo = true

	var d = falas[fala_atual]

	nome_label.text = d.get("nome", "")
	texto_label.text = ""

	if d.get("sprite"):
		retrato.texture = d["sprite"]

	await _animar_texto(d.get("texto", ""))

	escrevendo = false
	aguardando = true


func _animar_texto(texto: String) -> void:
	texto_label.text = texto

	for i in range(texto.length() + 1):
		texto_label.visible_ratio = float(i) / max(texto.length(), 1)
		await get_tree().create_timer(0.02).timeout


func _input(event):
	if not visible:
		return

	if not aguardando:
		return

	if event.is_action_pressed("ui_accept"):

		if escrevendo:
			texto_label.visible_ratio = 1
			escrevendo = false
			return

		_proxima_fala()


func _proxima_fala() -> void:
	fala_atual += 1

	if fala_atual < falas.size():
		_exibir_fala()
	else:
		visible = false
		emit_signal("dialogo_finalizado")
