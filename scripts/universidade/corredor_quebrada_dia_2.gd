extends Node2D

# SINAL CUSTOMIZADO PARA AS ESCOLHAS
signal escolha_feita(opcao)

@onready var player = $Protagonista
@onready var menina = $MeninaQuebrada
@onready var hud = $HudGameplayCorredor
@onready var dialogo = $HudDialogo/Control
@onready var overlay = $ColorRect

# REFERÊNCIAS DA SUA UI DE ESCOLHAS (Certifique-se de colar o CanvasLayer nesta cena também)
@onready var menu_escolhas = $CanvasLayer
@onready var label_situacao = $CanvasLayer/Panel/VBoxContainer/LabelSituacao
@onready var btn_opcao_a = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoA
@onready var btn_opcao_b = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoB
@onready var label_btn_a = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoA/Label
@onready var label_btn_b = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoB/Label

var encontro := false
var evento_final_rodando := false
var pode_sair := false # Controle para a saída do ônibus


func _ready() -> void:
	overlay.visible = true
	overlay.color = Color(0, 0, 0, 0.35)

	dialogo.visible = false
	menu_escolhas.visible = false

	# Conecta os botões
	btn_opcao_a.pressed.connect(_on_botao_a_pressionado)
	btn_opcao_b.pressed.connect(_on_botao_b_pressionado)

	player.travar()
	menina.set_player(player)

	# Conecta a área do primeiro encontro
	var area := menina.get_node_or_null("EncontroArea")
	if area:
		area.body_entered.connect(_on_encontro)

	# Conecta a área do isolamento (canto escuro)
	var area_isolada = get_node_or_null("AreaIsolada")
	if area_isolada:
		area_isolada.body_entered.connect(_on_area_isolada_entered)
		
	# Conecta a saída do ônibus
	var saida_onibus = get_node_or_null("SaidaOnibus")
	if saida_onibus:
		saida_onibus.body_entered.connect(_on_saida_entered)

	await intro()

	player.liberar()
	menina.iniciar()


# ==========================================
# INTRO E PRIMEIRO ENCONTRO
# ==========================================
func intro() -> void:
	await hud.mostrar("O corredor está mais silencioso hoje.")
	await hud.mostrar("Não parece vazio.")
	await hud.mostrar("Parece confortável demais.")
	await hud.mostrar("Como se nada precisasse ser dito.")
	await hud.esconder()

func _on_encontro(body: Node) -> void:
	if encontro or body != player: return
	encontro = true
	await _iniciar_encontro()

func _iniciar_encontro() -> void:
	player.travar()
	menina.parar()
	await hud_encontro()
	await iniciar_dialogo()

func hud_encontro() -> void:
	await hud.mostrar("Ela não bloqueia seu caminho.")
	await hud.mostrar("Só está ali.")
	await hud.mostrar("Como se já te conhecesse.")
	await hud.esconder()

func iniciar_dialogo() -> void:
	dialogo.visible = true
	var falas = [
		{
			"nome": "Menina Quebrada", 
			"texto": "Ei...", 
			"sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")
		},
		{
			"nome": "Menina Quebrada", 
			"texto": "Você deixou isso cair ontem no banheiro.", 
			"sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")
		},
		{
			"nome": "Menina Quebrada", 
			"texto": "Achei que você ia querer de volta.", 
			"sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")
		},
		{
			"nome": "Menina Quebrada", 
			"texto": "Se quiser conversar... ou só fugir um pouco do barulho... me encontra nas mesas perto da sala.", 
			"sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")
		}
	]
	dialogo.iniciar_dialogo(falas)
	await dialogo.dialogo_finalizado
	await pos_dialogo()

func pos_dialogo() -> void:
	await hud.mostrar("Ela não exige resposta.")
	await hud.mostrar("O silêncio entre vocês não pesa.")
	await hud.mostrar("Ele acolhe.")
	await hud.esconder()
	
	player.liberar()
	
	# NOVO COMPORTAMENTO: A menina vai para as mesas em vez de te seguir
	var ponto_espera = get_node_or_null("PontoEspera")
	
	if ponto_espera:
		# Nós passamos o marcador no lugar do 'player'. 
		# Como o marcador tem uma posição igual o player, ela vai andar até ele!
		menina.set_player(ponto_espera) 
		menina.iniciar()


# ==========================================
# EVENTO FINAL: O CANTO ISOLADO E A ESCOLHA
# ==========================================
func _on_area_isolada_entered(body: Node) -> void:
	if body != player or not encontro or evento_final_rodando:
		return
	evento_final_rodando = true
	await _iniciar_isolamento()

func _iniciar_isolamento() -> void:
	player.travar()
	menina.parar()
	
	dialogo.visible = true
	
	var falas_iniciais = [
		{"nome": "Menina Quebrada", "texto": "Você não precisa voltar pra lá se não quiser. Ninguém liga de verdade.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")},
		{"nome": "Menina Quebrada", "texto": "A gente pode ficar aqui. É mais seguro.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")}
	]
	
	dialogo.iniciar_dialogo(falas_iniciais)
	await dialogo.dialogo_finalizado
	
	# Prepara a Tela de Escolhas
	label_situacao.text = "O que você decide?"
	label_btn_a.text = "Acho que vou ficar aqui. O barulho me cansa."
	label_btn_b.text = "Eu devia voltar... mas não consigo. Dói muito."
	menu_escolhas.visible = true 
	
	# Pausa o código e espera o jogador clicar
	var resposta_escolhida = await escolha_feita 
	
	dialogo.visible = true
	if resposta_escolhida == 0:
		# Opção A (Aceitando o Isolamento)
		var falas_opcao_a = [
			{"nome": "Protagonista", "texto": "Acho que vou ficar aqui. O barulho me cansa.", "sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")}, # Troque para a foto da prota
			{"nome": "Menina Quebrada", "texto": "Eu sei. Aqui é silencioso. Pode sentar.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")}
		]
		dialogo.iniciar_dialogo(falas_opcao_a)
		await dialogo.dialogo_finalizado
		# Matemática: Cai Ansiedade, Sobe bastante Isolamento e Vínculo Quebrado
		GameState.alterar_estado(-15, 20, 0, 0, 20)
		
	elif resposta_escolhida == 1:
		# Opção B (Vulnerabilidade/Culpa)
		var falas_opcao_b = [
			{"nome": "Protagonista", "texto": "Eu devia voltar... mas não consigo. Dói muito.", "sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")}, # Troque para a foto da prota
			{"nome": "Menina Quebrada", "texto": "Tá tudo bem. Você não precisa forçar nada hoje.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")}
		]
		dialogo.iniciar_dialogo(falas_opcao_b)
		await dialogo.dialogo_finalizado
		# Matemática: Cai um pouco Ansiedade, Sobe Isolamento, Vínculo e um pouco de Confiança por desabafar
		GameState.alterar_estado(-5, 10, 5, 0, 15)
		
	await pos_isolamento()

func pos_isolamento() -> void:
	await hud.mostrar("O barulho da aula fica abafado aqui fora.")
	await hud.mostrar("É mais fácil simplesmente desaparecer.")
	await hud.mostrar("O tempo passa. Você percebe que a aula já deve ter acabado.")
	await hud.esconder()
	
	pode_sair = true
	player.liberar()


# ==========================================
# SAÍDA PARA O ÔNIBUS
# ==========================================
func _on_saida_entered(body: Node) -> void:
	if not pode_sair or body != player:
		return
		
	player.travar()
	
	await hud.mostrar("Você caminha de volta pelo corredor vazio.")
	await hud.mostrar("Um dia inteiro se passou, mas você não sentiu o tempo correr.")
	await hud.esconder()
	
	get_tree().change_scene_to_file("res://scenes/onibus/PontoDeOnibus.tscn")


# ==========================================
# FUNÇÕES DOS BOTÕES (SINAIS)
# ==========================================
func _on_botao_a_pressionado() -> void:
	menu_escolhas.visible = false 
	escolha_feita.emit(0)

func _on_botao_b_pressionado() -> void:
	menu_escolhas.visible = false 
	escolha_feita.emit(1)
