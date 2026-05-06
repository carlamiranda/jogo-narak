extends Control

#elementos da tela
@onready var label_situacao: Label = $CanvasLayer/Panel/VBoxContainer/LabelSituacao
@onready var botao_a: Button = $CanvasLayer/Panel/VBoxContainer/ButtonOpcaoA
@onready var botao_b: Button = $CanvasLayer/Panel/VBoxContainer/ButtonOpcaoB


#começa mostrando a primeira escolha
func _ready() -> void:
	mostrar_escolha_inicial()

#mostra a escolha inicial do jogo
func mostrar_escolha_inicial() -> void:
	label_situacao.text = "Você chega à universidade. As vozes parecem altas demais. O que fazer?"

	botao_a.text = "Enfrentar a sala"
	botao_b.text = "Ir para o banheiro"

	botao_a.visible = true
	botao_b.visible = true

	botao_a.pressed.connect(escolher_sala)
	botao_b.pressed.connect(escolher_banheiro)


#escolha da rota a: caminho colorido
func escolher_sala() -> void:
	GameState.definir_rota("colorida")
	GameState.alterar_estado(10, -10, 10, 20, 0)

	print("Escolheu sala")
	print("Rota: ", GameState.rota_atual)
	print("Ansiedade: ", GameState.ansiedade)
	print("Isolamento: ", GameState.isolamento)
	print("Confiança: ", GameState.confianca)
	print("Vínculo Colorida: ", GameState.vinculo_colorida)
	print("Vínculo Quebrada: ", GameState.vinculo_quebrada)

	label_situacao.text = "Você entra na sala. A ansiedade aumenta, mas uma presença colorida começa a chamar sua atenção."

	botao_a.text = "Continuar"
	botao_b.visible = false

	if botao_a.pressed.is_connected(escolher_sala):
		botao_a.pressed.disconnect(escolher_sala)

	botao_a.pressed.connect(ir_para_final_rota_a)


#escolha da rota b: caminho espelho
func escolher_banheiro() -> void:
	GameState.definir_rota("espelho")
	GameState.alterar_estado(-5, 15, 0, 0, 20)

	print("Escolheu banheiro")
	print("Rota: ", GameState.rota_atual)
	print("Ansiedade: ", GameState.ansiedade)
	print("Isolamento: ", GameState.isolamento)
	print("Confiança: ", GameState.confianca)
	print("Vínculo Colorida: ", GameState.vinculo_colorida)
	print("Vínculo Quebrada: ", GameState.vinculo_quebrada)

	label_situacao.text = "Você corre para o banheiro. O silêncio parece seguro, mas também pesado."

	botao_a.text = "Atender ligação no final"
	botao_b.text = "Ignorar ligação no final"

	botao_a.visible = true
	botao_b.visible = true

	if botao_a.pressed.is_connected(escolher_sala):
		botao_a.pressed.disconnect(escolher_sala)

	if botao_b.pressed.is_connected(escolher_banheiro):
		botao_b.pressed.disconnect(escolher_banheiro)

	botao_a.pressed.connect(atender_ligacao)
	botao_b.pressed.connect(ignorar_ligacao)

#leva ao fina da rota a
func ir_para_final_rota_a() -> void:
	GameState.definir_final(GameState.calcular_final())
	mostrar_final()


#escolha positiva rota b
func atender_ligacao() -> void:
	GameState.atendeu_ligacao = true

	#diminui isolamento e aumenta confiança
	GameState.alterar_estado(-20, -20, 30, 30, -10)

	GameState.definir_final(GameState.calcular_final())
	mostrar_final()


#escolha negativa da rota b
func ignorar_ligacao() -> void:
	GameState.atendeu_ligacao = false

	#aumenta isolamento e aproxima da rota negativa
	GameState.alterar_estado(10, 30, -10, -20, 20)

	GameState.definir_final(GameState.calcular_final())
	mostrar_final()


#mostrar o final alcançado
func mostrar_final() -> void:
	botao_b.visible = false
	botao_a.text = "Reiniciar"

	match GameState.final_atual:
		"superacao":
			label_situacao.text = "Final 1: Superação\n\nA protagonista aceita ajuda, começa a terapia e o mundo volta a ganhar cor."

		"despertar":
			label_situacao.text = "Final 2: O Despertar\n\nEla atende à ligação, percebe que precisa sair daquele ciclo e decide tentar novamente."

		"vazio":
			label_situacao.text = "Final 3: O Vazio\n\nEla ignora a última conexão com a luz e retorna ao silêncio."

		_:
			label_situacao.text = "Final indefinido."

	#limpa funções antigas dos botões
	if botao_a.pressed.is_connected(ir_para_final_rota_a):
		botao_a.pressed.disconnect(ir_para_final_rota_a)

	if botao_a.pressed.is_connected(atender_ligacao):
		botao_a.pressed.disconnect(atender_ligacao)

	if botao_b.pressed.is_connected(ignorar_ligacao):
		botao_b.pressed.disconnect(ignorar_ligacao)

	botao_a.pressed.connect(reiniciar)


#reinicia o jogo
func reiniciar() -> void:
	GameState.resetar_jogo()
	get_tree().reload_current_scene()
