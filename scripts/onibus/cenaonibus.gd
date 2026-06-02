extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

var versao_popup := 0

@export var largura: float = 420.0
@export var altura: float = 150.0

@export var margem_x: float = 42.0
@export var margem_y: float = 28.0

@export var altura_cauda: float = 45.0
@export var tamanho_fonte: int = 18


func _ready() -> void:
	visible = false
	z_index = 100

	if sprite != null:
		sprite.centered = true
		sprite.z_index = 100

	if label != null:
		label.z_index = 101
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.add_theme_font_size_override("font_size", tamanho_fonte)


func mostrar_prompt_interacao(texto: String) -> void:
	versao_popup += 1
	label.text = texto
	ajustar_tamanho()
	visible = true
	scale = Vector2.ONE
	modulate.a = 1.0


func mostrar_confirmacao_animacao(mensagem: String, tempo: float = 1.5) -> void:
	versao_popup += 1
	var versao_atual = versao_popup

	label.text = mensagem
	ajustar_tamanho()
	visible = true

	scale = Vector2(0.8, 0.8)
	modulate.a = 0.0

	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.15)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.15)

	await get_tree().create_timer(tempo).timeout

	if versao_atual == versao_popup:
		var tween_saida = create_tween()
		tween_saida.parallel().tween_property(self, "scale", Vector2(0.9, 0.9), 0.15)
		tween_saida.parallel().tween_property(self, "modulate:a", 0.0, 0.15)
		await tween_saida.finished
		visible = false


func esconder() -> void:
	versao_popup += 1
	visible = false


func ajustar_tamanho() -> void:
	if sprite != null and sprite.texture != null:
		var textura_tamanho = sprite.texture.get_size()
		sprite.scale = Vector2(
			largura / textura_tamanho.x,
			altura / textura_tamanho.y
		)

	if label == null:
		return

	label.add_theme_font_size_override("font_size", tamanho_fonte)

	var largura_label := largura - margem_x * 2.0
	var altura_label := altura - margem_y * 2.0 - altura_cauda

	label.size = Vector2(largura_label, altura_label)
	label.position = Vector2(
		-largura_label / 2.0,
		-(altura / 2.0) + margem_y
	)
