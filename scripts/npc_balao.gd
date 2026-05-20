extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

var versao_balao := 0

@export var largura_minima: float = 260.0
@export var largura_maxima: float = 460.0

@export var altura_minima: float = 100.0
@export var altura_por_linha: float = 30.0
@export var caracteres_por_linha: int = 24

# Margens internas para o texto não encostar na borda
@export var margem_x: float = 38.0
@export var margem_y: float = 22.0

# Espaço reservado para a cauda do balão
@export var altura_cauda: float = 35.0


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


func mostrar_fala(texto: String, tempo: float = 3.0) -> void:
	versao_balao += 1
	var versao_atual = versao_balao

	ajustar_tamanho(texto)

	label.text = texto
	visible = true

	await get_tree().create_timer(tempo).timeout

	if versao_atual == versao_balao:
		visible = false


func esconder() -> void:
	versao_balao += 1
	visible = false


func ajustar_tamanho(texto: String) -> void:
	var quantidade_caracteres: int = texto.length()

	var quantidade_linhas: int = int(ceil(float(quantidade_caracteres) / float(caracteres_por_linha)))
	quantidade_linhas = max(1, quantidade_linhas)

	var largura: float = float(caracteres_por_linha) * 10.0
	largura = clamp(largura, largura_minima, largura_maxima)

	var altura_texto: float = float(quantidade_linhas) * altura_por_linha
	var altura: float = altura_texto + (margem_y * 2.0) + altura_cauda
	altura = max(altura, altura_minima)

	# Ajusta o tamanho visual do sprite do balão
	if sprite != null and sprite.texture != null:
		var textura_tamanho: Vector2 = sprite.texture.get_size()

		sprite.scale = Vector2(
			largura / textura_tamanho.x,
			altura / textura_tamanho.y
		)

	# Ajusta a área do texto sem escalar a fonte
	if label != null:
		var largura_label: float = largura - (margem_x * 2.0)
		var altura_label: float = altura - (margem_y * 2.0) - altura_cauda

		label.size = Vector2(largura_label, altura_label)

		# Coloca o texto na parte principal do balão, sem pegar a cauda
		label.position = Vector2(
			-largura_label / 2.0,
			-(altura / 2.0) + margem_y
		)
