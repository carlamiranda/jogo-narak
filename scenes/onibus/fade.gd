extends CanvasLayer

@onready var fade = $ColorRect
@onready var label = get_node_or_null("Label")


func _ready():

	fade.visible = true
	fade.modulate = Color(0, 0, 0, 0)

	if label == null:
		push_error("❌ Label não encontrado dentro do CutsceneLayer!")
		return

	label.visible = true
	label.text = ""


func mostrar_fala(txt: String, time := 1.5) -> void:

	if label == null:
		return

	label.visible = true
	label.text = txt

	await get_tree().process_frame
	await get_tree().process_frame

	await get_tree().create_timer(time).timeout

	label.text = ""


func fade_out(time := 0.3) -> void:

	fade.visible = true

	var t := 0.0

	while t < time:
		t += get_process_delta_time()
		var a = t / time
		fade.modulate = Color(0, 0, 0, a)
		await get_tree().process_frame

	fade.modulate = Color(0, 0, 0, 1)
