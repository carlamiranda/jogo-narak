extends CanvasLayer

@onready var fade: ColorRect = $ColorRect
@onready var label = get_node_or_null("Label")

var ativo := false


func _ready():
	fade.modulate.a = 0.0

	if label:
		label.modulate.a = 0.0
		label.visible = false

	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE


func play_fade_out(time := 1.0):

	ativo = true
	fade.visible = true

	var t = create_tween()
	t.tween_property(fade, "modulate:a", 1.0, time)

	await t.finished


func play_fade_in(time := 1.0):

	var t = create_tween()
	t.tween_property(fade, "modulate:a", 0.0, time)

	await t.finished

	fade.visible = false
	ativo = false


func show_text(texto: String, tempo := 2.0):

	if label == null:
		push_error("Cutscene: Label não encontrado!")
		return

	label.text = texto
	label.visible = true
	label.modulate.a = 0.0

	var t = create_tween()
	t.tween_property(label, "modulate:a", 1.0, 0.4)

	await get_tree().create_timer(tempo).timeout

	var t2 = create_tween()
	t2.tween_property(label, "modulate:a", 0.0, 0.4)
	await t2.finished

	label.visible = false
