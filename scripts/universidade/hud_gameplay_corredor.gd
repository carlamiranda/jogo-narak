extends CanvasLayer

signal avancar

@onready var label: Label = $Panel/MarginContainer/Label
@onready var panel: Panel = $Panel

var esperando := false

func _ready() -> void:
	panel.visible = false
	panel.modulate.a = 0.0

func mostrar(texto: String) -> void:
	label.text = texto
	panel.visible = true
	esperando = true

	var t = create_tween()
	t.tween_property(panel, "modulate:a", 1.0, 0.2)

	await get_tree().process_frame
	await avancar

	esperando = false

func esconder() -> void:
	var t = create_tween()
	t.tween_property(panel, "modulate:a", 0.0, 0.2)
	await t.finished
	panel.visible = false

func _input(event):
	if esperando and event.is_action_pressed("ui_accept"):
		avancar.emit()
