extends Control

@onready var retrato = $Panel/retrato
@onready var nome_label = $Panel/nome
@onready var texto_label = $Panel/texto
@onready var timer = $Panel/LetterTimer

var falas = []
var fala_atual = 0

func iniciar_dialogo(lista_fala):
	falas = lista_fala
	fala_atual = 0
	exibir_fala()

func _input(event):
	# Se apertar Espaço ou clique e o texto já acabou de escrever, passa para a próxima
	if event.is_action_pressed("ui_accept") or event is InputEventMouseButton:
		if texto_label.visible_ratio < 1:
			texto_label.visible_ratio = 1 # Pula a animação de escrever
		else:
			proxima_fala()

func exibir_fala():
	var dados = falas[fala_atual]
	nome_label.text = dados["nome"]
	texto_label.text = dados["texto"]
	retrato.texture = dados["sprite"]
	
	# Efeito de digitar
	texto_label.visible_ratio = 0
	timer.start()

func proxima_fala():
	fala_atual += 1
	if fala_atual < falas.size():
		exibir_fala()
	else:
		queue_free() # Fecha o diálogo ao acabar

func _on_letter_timer_timeout():
	if texto_label.visible_ratio < 1:
		texto_label.visible_ratio += 0.05 # Velocidade da escrita
	else:
		timer.stop()
