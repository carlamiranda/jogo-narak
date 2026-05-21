extends CanvasLayer

signal avancar_dialogo 

@onready var panel = $Panel
@onready var label = $Panel/MarginContainer/Label

func _ready():
	panel.visible = false
	panel.modulate.a = 0.0

func show_message(texto: String):
	label.text = texto
	
	if not panel.visible:
		panel.visible = true
		var t = create_tween()
		t.tween_property(panel, "modulate:a", 1.0, 0.25)
		await t.finished

func hide_message():
	var t = create_tween()
	t.tween_property(panel, "modulate:a", 0.0, 0.25)
	await t.finished
	panel.visible = false

func _input(event):
	if panel.visible and event.is_action_pressed("ui_accept"):
		emit_signal("avancar_dialogo")
