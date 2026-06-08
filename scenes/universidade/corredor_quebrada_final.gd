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

	# Conecta a área do encontro (Hitbox da menina)
	var area := menina.get_node_or_null("EncontroArea")
	if area:
		area.body_entered.connect(_on_encontro)

	await intro()

	player.liberar()


# ==========================================
# INTRO
# ==========================================
func intro() -> void:
	await hud.mostrar("Já se passaram meses desde que começamos a andar juntas.")
	await hud.mostrar("O corredor é suportável quando nos escondemos dele.")
	await hud.mostrar("Mas... eu sinto que estamos paradas no tempo.")
	await hud.esconder()


# ==========================================
# O ENCONTRO E A DISCUSSÃO
# ==========================================
func _on_encontro(body: Node) -> void:
	if encontro or body != player: return
	encontro = true
	await _iniciar_encontro()


func _iniciar_encontro() -> void:
	player.travar()
	await iniciar_dialogo_discussao()


func iniciar_dialogo_discussao() -> void:
	dialogo.visible = true
	
	# Primeira parte da conversa (A Irresponsabilidade)
	var falas_iniciais = [
		{"nome": "Menina Quebrada", "texto": "Ei. Que bom que te achei.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")},
		{"nome": "Menina Quebrada", "texto": "Tô indo matar a prova de amanhã cedo pra ir numa festa hoje à noite. Vem comigo.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")},
		{"nome": "Protagonista", "texto": "Festa? Mas... a gente tem uma prova decisiva. Eu não posso reprovar de novo.", "sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")},
		{"nome": "Menina Quebrada", "texto": "E daí? Ninguém liga de verdade pra isso. A gente reprova juntas, não tem problema.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")},
		{"nome": "Menina Quebrada", "texto": "É muito melhor esquecer de tudo lá fora do que tentar e falhar. A gente não precisa disso.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")},
		{"nome": "Protagonista", "texto": "Mas eu... eu acho que eu preciso tentar.", "sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")},
		{"nome": "Menina Quebrada", "texto": "Sério que você vai me deixar ir sozinha e jogar a noite fora por causa de uma prova inútil? Achei que a gente se entendia.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")}
	]
	
	dialogo.iniciar_dialogo(falas_iniciais)
	await dialogo.dialogo_finalizado
	
	# ==========================================
	# TELA DE ESCOLHAS
	# ==========================================
	label_situacao.text = "Por que você não vai?"
	label_btn_a.text = "Preciso pensar no meu futuro e em mim."
	label_btn_b.text = "A festa me assusta. Só quero me esconder."
	menu_escolhas.visible = true 
	
	var resposta_escolhida = await escolha_feita 
	
	dialogo.visible = true
	
	if resposta_escolhida == 0:
		# OPÇÃO A: SE COLOCA EM PRIMEIRO LUGAR
		var falas_opcao_a = [
			{"nome": "Protagonista", "texto": "Desculpa. Eu não vou me afundar nisso. Eu preciso tentar melhorar, por mim.", "sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")},
			{"nome": "Menina Quebrada", "texto": "Nossa... tá bom então. Boa sorte tentando ser normal.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")}
		]
		dialogo.iniciar_dialogo(falas_opcao_a)
		await dialogo.dialogo_finalizado
		
		GameState.alterar_estado(10, -20, 25, 10, -15) # Exemplo: Sobe Confiança, Cai Ansiedade/Isolamento
		await final_prioridade()
		
	elif resposta_escolhida == 1:
		# OPÇÃO B: FOGE POR MEDO/EVITAÇÃO
		var falas_opcao_b = [
			{"nome": "Protagonista", "texto": "Eu não consigo ir pra uma festa. Tem gente demais... eu só quero sumir na minha cama.", "sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")},
			{"nome": "Menina Quebrada", "texto": "Eu entendo. O mundo lá fora é um inferno mesmo. Fica em casa, eu fujo por nós duas.", "sprite": preload("res://assets/sprites/characters/broken_girl/portrait/broken_girl_portrait.png")}
		]
		dialogo.iniciar_dialogo(falas_opcao_b)
		await dialogo.dialogo_finalizado
		
		GameState.alterar_estado(-10, 20, -15, -10, 25) # Exemplo: Sobe Ansiedade e Isolamento
		await final_fuga()


# ==========================================
# RESOLUÇÕES (FINAIS DO JOGO)
# ==========================================
func final_prioridade() -> void:
	await cutscene.play_fade_out(1.0)
	
	await cutscene.show_text("Eu vi ela virar as costas e ir embora.", 3.0)
	await cutscene.show_text("Doeu. Doeu muito deixar ela para trás.", 3.5)
	await cutscene.show_text("Mas, pela primeira vez, eu não me destruí para caber no vazio de alguém.", 4.0)
	await cutscene.show_text("O caminho para melhorar ainda é longo e assustador...", 3.5)
	await cutscene.show_text("...mas pelo menos agora, eu escolhi lutar por mim.", 4.0)
	
	await get_tree().create_timer(1.0).timeout
	await cutscene.show_text("FIM.", 4.0)
	await get_tree().create_timer(1.0).timeout
	
	# Troca para a cena de Créditos ou Menu Inicial
	# ⚠️ LEMBRE-SE DE COLOCAR O CAMINHO CORRETO AQUI:
	get_tree().change_scene_to_file("res://scenes/menus/menu_principal.tscn")


func final_fuga() -> void:
	await cutscene.play_fade_out(1.0) 
	
	await cutscene.show_text("Eu fugi da festa. Fugi da aula. Fugi de mim mesma.", 3.5)
	await cutscene.show_text("O medo me protegeu do mundo lá fora...", 3.5)
	await cutscene.show_text("...mas me manteve presa em uma gaiola que eu mesma criei.", 4.0)
	await cutscene.show_text("Nós duas escolhemos afundar juntas, abraçadas no conforto do escuro.", 4.0)
	
	await get_tree().create_timer(1.0).timeout
	await cutscene.show_text("FIM.", 4.0)
	await get_tree().create_timer(1.0).timeout
	
	# Troca para a cena de Créditos ou Menu Inicial
	# ⚠️ LEMBRE-SE DE COLOCAR O CAMINHO CORRETO AQUI:
	get_tree().change_scene_to_file("res://scenes/menus/menu_principal.tscn")


# ==========================================
# FUNÇÕES DOS BOTÕES (SINAIS)
# ==========================================
func _on_botao_a_pressionado() -> void:
	menu_escolhas.visible = false 
	escolha_feita.emit(0)

func _on_botao_b_pressionado() -> void:
	menu_escolhas.visible = false 
	escolha_feita.emit(1)
