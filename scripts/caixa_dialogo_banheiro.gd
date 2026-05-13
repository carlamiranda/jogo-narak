extends Control

@onready var retrato = $Panel/retrato
@onready var nome_label = $Panel/nome
@onready var texto_label = $Panel/texto
@onready var timer = $Panel/LetterTimer

var falas = []
var fala_atual = 0
var automatico = false


func iniciar_dialogo(lista_falas, auto = false):

	falas = lista_falas
	fala_atual = 0
	automatico = auto

	visible = true

	exibir_fala()


func exibir_fala():

	var dados = falas[fala_atual]

	nome_label.text = dados["nome"]
	texto_label.text = dados["texto"]
	retrato.texture = dados["sprite"]

	# ====================================
	# AUTOMÁTICO
	# ====================================

	if automatico:

		texto_label.visible_ratio = 1

		await get_tree().create_timer(2.0).timeout

		proxima_fala()

	# ====================================
	# MANUAL
	# ====================================

	else:

		texto_label.visible_ratio = 0

		timer.start()


func _process(delta):

	# automático não usa botão
	if automatico:
		return

	if not visible:
		return

	if Input.is_action_just_pressed("ui_accept"):

		if texto_label.visible_ratio < 1:

			texto_label.visible_ratio = 1

		else:

			proxima_fala()


func proxima_fala():

	fala_atual += 1

	if fala_atual < falas.size():

		exibir_fala()

	else:

		visible = false


func _on_letter_timer_timeout():

	if texto_label.visible_ratio < 1:

		texto_label.visible_ratio += 0.08

	else:

		timer.stop()
