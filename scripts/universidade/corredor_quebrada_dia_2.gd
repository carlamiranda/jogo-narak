extends Node2D

# SINAL CUSTOMIZADO PARA AS ESCOLHAS
signal escolha_feita(opcao)

@onready var player = $Protagonista
@onready var menina = $MeninaQuebrada
@onready var hud = $HudGameplayCorredor
@onready var dialogo = $HudDialogo/Control
@onready var overlay = $ColorRect
@onready var cutscene = $CutsceneUI

# REFERÊNCIAS DA SUA UI DE ESCOLHAS
@onready var menu_escolhas = $CanvasLayer
@onready var label_situacao = $CanvasLayer/Panel/VBoxContainer/LabelSituacao
@onready var btn_opcao_a = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoA
@onready var btn_opcao_b = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoB
@onready var label_btn_a = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoA/Label
@onready var label_btn_b = $CanvasLayer/Panel/VBoxContainer/HBoxContainer/ButtonOpcaoB/Label

var encontro := false
var evento_final_rodando := false


func _ready() -> void:
	overlay.visible = true
	overlay.color = Color(0, 0, 0, 0.35)

	dialogo.visible = false
	if menu_escolhas:
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

	# Conecta a área do isolamento (canto escuro/mesas)
	var area_isolada = get_node_or_null("AreaIsolada")
	if area_isolada:
		area_isolada.body_entered.connect(_on_area_isolada_entered)

	await intro()

	player.liberar()
	menina.iniciar()


# ==========================================
# INTRO E PRIMEIRO ENCONTRO
# ==========================================
func intro() -> void:
	await hud.mostrar("O corredor está tão silencioso hoje.")
	await hud.mostrar("Não tem ninguém gritando. Ninguém me empurrando.")
	await hud.mostrar("É um vazio... surpreendentemente confortável.")
	await hud.mostrar("Pelo menos aqui eu não preciso fingir que sei existir.")
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
	await hud.mostrar("Alguém se aproximou. Minha respiração travou.")
	await hud.mostrar("Mas... ela não entrou no meu caminho.")
	await hud.mostrar("Ela só está ali. Quase invisível, igual a mim.")
	await hud.esconder()


func iniciar_dialogo() -> void:
	dialogo.visible = true
	var falas = [
		{"nome": "Menina Quebrada", "texto": "Ei...", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")},
		{"nome": "Menina Quebrada", "texto": "Você deixou isso cair ontem no banheiro.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")},
		{"nome": "Menina Quebrada", "texto": "Achei que você ia querer de volta.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")},
		{"nome": "Menina Quebrada", "texto": "Se quiser conversar... ou só fugir um pouco do barulho... me encontra nas mesas perto da sala.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")}
	]
	dialogo.iniciar_dialogo(falas)
	await dialogo.dialogo_finalizado
	await pos_dialogo()


func pos_dialogo() -> void:
	await hud.mostrar("Ela falou e foi embora. Sem esperar eu gaguejar.")
	await hud.mostrar("Esse silêncio... é a primeira vez que ele não me sufoca.")
	await hud.esconder()
	
	player.liberar()
	
	# A menina vai para as mesas esperar por você
	var ponto_espera = get_node_or_null("PontoEspera")
	if ponto_espera:
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
		{"nome": "Menina Quebrada", "texto": "Você não precisa ir pra aula se não quiser. Ninguém liga de verdade.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")},
		{"nome": "Menina Quebrada", "texto": "A gente pode ficar aqui. é quieto", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")}
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
		var falas_opcao_a = [
			{"nome": "Protagonista", "texto": "Acho que vou ficar aqui. O barulho me cansa.", "sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")},
			{"nome": "Menina Quebrada", "texto": "Eu sei. Aqui é silencioso. Pode sentar.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")}
		]
		dialogo.iniciar_dialogo(falas_opcao_a)
		await dialogo.dialogo_finalizado
		GameState.alterar_estado(-15, 20, 0, 0, 20)
		
	elif resposta_escolhida == 1:
		var falas_opcao_b = [
			{"nome": "Protagonista", "texto": "Eu devia voltar... mas não consigo.", "sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")},
			{"nome": "Menina Quebrada", "texto": "Tá tudo bem. Você não precisa ir pra aula hoje.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")}
		]
		dialogo.iniciar_dialogo(falas_opcao_b)
		await dialogo.dialogo_finalizado
		GameState.alterar_estado(-5, 10, 5, 0, 15)
		
	await pos_isolamento()


func pos_isolamento() -> void:
	await hud.mostrar("As vozes da sala parecem muito distantes daqui de fora.")
	await hud.mostrar("Sumir é tão mais fácil do que tentar existir lá dentro.")
	await hud.mostrar("O tempo passa... O inferno acabou por hoje.")
	await hud.esconder()
	
	# Inicia o Time Skip diretamente daqui, sem voltar a andar
	await iniciar_time_skip()


# ==========================================
# TIME SKIP (TRANSIÇÃO FINAL)
# ==========================================
func iniciar_time_skip() -> void:
	# --- ESCURECE A TELA ---
	await cutscene.play_fade_out(1.0) 
	
	# Frases de hesitação na tela preta
	await cutscene.show_text("Pela primeira vez, não me senti um fardo.", 2.5)
	await cutscene.show_text("Será que eu deveria procurar ela de novo amanhã?", 2.5)
	await cutscene.show_text("E se a gente apenas ficasse em silêncio juntas?", 2.5)
	await cutscene.show_text("Acho que... eu gostaria disso.", 2.5)
	
	# Pausa dramática no escuro
	await get_tree().create_timer(1.0).timeout
	
	# O grande salto no tempo
	await cutscene.show_text("4 MESES DEPOIS", 3.0)
	
	# Outra pausa curta antes de abrir a nova cena
	await get_tree().create_timer(0.5).timeout
	
	# Vai para a cena final (lembre-se de atualizar o caminho abaixo!)
	get_tree().change_scene_to_file("res://scenes/universidade/corredor_quebrada_final.tscn")


# ==========================================
# FUNÇÕES DOS BOTÕES (SINAIS)
# ==========================================
func _on_botao_a_pressionado() -> void:
	menu_escolhas.visible = false 
	escolha_feita.emit(0)

func _on_botao_b_pressionado() -> void:
	menu_escolhas.visible = false 
	escolha_feita.emit(1)
