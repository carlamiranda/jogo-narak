extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

var versao_popup := 0
var _escala_correcao := Vector2.ONE
var _largura_atual := 320.0
var _altura_atual := 120.0

@export var largura_minima: float = 260.0
@export var largura_maxima: float = 420.0
@export var altura_minima: float = 110.0
@export var altura_por_linha: float = 28.0
@export var caracteres_por_linha: int = 22

@export var margem_x: float = 42.0
@export var margem_y: float = 28.0
@export var altura_cauda: float = 45.0
@export var tamanho_fonte: int = 16


func _ready() -> void:
	visible = false
	z_index = 100

	if sprite != null:
		sprite.centered = true
		sprite.z_index = 100

	if label != null:
		label.z_index = 101
		label.scale = Vector2.ONE
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.add_theme_font_size_override("font_size", tamanho_fonte)

	call_deferred("_recalcular_escala_correcao")


func _escala_acumulada_pais() -> Vector2:
	var acumulado := Vector2.ONE
	var no := get_parent()

	while no != null:
		if no is CanvasItem:
			acumulado.x *= absf(no.scale.x)
			acumulado.y *= absf(no.scale.y)
		no = no.get_parent()

	return acumulado


func _recalcular_escala_correcao() -> void:
	scale = Vector2.ONE

	var correcao := Vector2.ONE
	var gt := global_transform

	if gt.x.x < 0.0:
		correcao.x = -1.0
	if gt.y.y < 0.0:
		correcao.y = -1.0

	var escala_pais := _escala_acumulada_pais()
	if escala_pais.x > 0.001 and escala_pais.y > 0.001:
		correcao.y *= escala_pais.x / escala_pais.y

	_escala_correcao = correcao
	scale = _escala_correcao


func _escala_anim(fator: float) -> Vector2:
	return _escala_correcao * fator


func mostrar_prompt_interacao(texto: String) -> void:
	versao_popup += 1
	_recalcular_escala_correcao()
	ajustar_tamanho(texto)
	label.text = texto
	visible = true
	scale = _escala_correcao
	modulate.a = 1.0


func mostrar_confirmacao_animacao(mensagem: String, tempo: float = 1.5) -> void:
	versao_popup += 1
	var versao_atual = versao_popup

	_recalcular_escala_correcao()
	ajustar_tamanho(mensagem)
	label.text = mensagem
	visible = true

	scale = _escala_anim(0.8)
	modulate.a = 0.0

	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", _escala_correcao, 0.15)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.15)

	await get_tree().create_timer(tempo).timeout

	if versao_atual == versao_popup:
		var tween_saida = create_tween()
		tween_saida.parallel().tween_property(self, "scale", _escala_anim(0.9), 0.15)
		tween_saida.parallel().tween_property(self, "modulate:a", 0.0, 0.15)
		await tween_saida.finished
		visible = false


func esconder() -> void:
	versao_popup += 1
	visible = false


func ajustar_tamanho(texto: String = "") -> void:
	if texto.is_empty() and label != null:
		texto = label.text

	var quantidade_linhas := maxi(1, ceili(float(texto.length()) / float(caracteres_por_linha)))
	var largura := clampf(float(caracteres_por_linha) * 10.0, largura_minima, largura_maxima)
	var altura_texto := float(quantidade_linhas) * altura_por_linha
	var altura := maxf(altura_minima, altura_texto + (margem_y * 2.0) + altura_cauda)

	_largura_atual = largura
	_altura_atual = altura

	if sprite != null and sprite.texture != null:
		var textura_tamanho := sprite.texture.get_size()
		var fator := maxf(largura / textura_tamanho.x, altura / textura_tamanho.y)
		sprite.scale = Vector2(fator, fator)

	if label == null:
		return

	label.scale = Vector2.ONE
	label.add_theme_font_size_override("font_size", tamanho_fonte)

	var largura_label := largura - margem_x * 2.0
	var altura_label := altura - margem_y * 2.0 - altura_cauda

	label.size = Vector2(largura_label, altura_label)
	label.position = Vector2(
		-largura_label / 2.0,
		-(altura / 2.0) + margem_y
	)
