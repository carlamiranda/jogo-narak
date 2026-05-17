extends CanvasLayer

@onready var panel = $Panel
@onready var label = $Panel/MarginContainer/Label

func _ready():
	panel.visible = false
	panel.modulate.a = 0.0


func show_message(texto: String, tempo := 2.5):
	label.text = texto
	panel.visible = true

	var t = create_tween()
	t.tween_property(panel, "modulate:a", 1.0, 0.25)

	await get_tree().create_timer(tempo).timeout

	var t2 = create_tween()
	t2.tween_property(panel, "modulate:a", 0.0, 0.25)
	await t2.finished

	panel.visible = false
