extends Node2D

@export var texto_intro: String = "O ônibus está meio cheio. Procure um lugar ideal para relaxar."
@export var tempo_texto: float = 3.5
@export var tempo_fade_entrada: float = 1.0

@onready var protagonista: CharacterBody2D = $Insidebus/StaticBody2D/Protagonista


func _ready() -> void:
	if protagonista != null:
		protagonista.travar()

	await get_tree().process_frame
	await _intro()

	if protagonista != null:
		protagonista.liberar()


func _intro() -> void:
	await Cutscene.play_fade_out(0.0)
	await Cutscene.show_text(texto_intro, tempo_texto)
	await Cutscene.play_fade_in(tempo_fade_entrada)
