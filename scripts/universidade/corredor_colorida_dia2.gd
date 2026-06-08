extends Node2D

# SINAL CUSTOMIZADO PARA AS ESCOLHAS
signal escolha_feita(opcao)

@onready var player = $Protagonista
@onready var menina = $MeninaColorida
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
	overlay.color = Color(0, 0, 0, 0.25)
	
	dialogo.visible = false
	menu_escolhas.visible = false

	btn_opcao_a.pressed.connect(_on_botao_a_pressionado)
	btn_opcao_b.pressed.connect(_on_botao_b_pressionado)

	player.travar()
	menina.set_player(player)

	# Conecta a área do primeiro encontro
	var area: Area2D = menina.get_node("EncontroArea")
	area.body_entered.connect(_on_encontro)
	
	# Conecta a área do almoço
	var area_almoco = get_node_or_null("AreaAlmoco")
	if area_almoco:
		area_almoco.body_entered.connect(_on_area_almoco_entered)

	await intro()

	player.liberar()
	menina.iniciar()


# ==========================================
# INTRO E PRIMEIRO ENCONTRO
# ==========================================
func intro() -> void:
	await hud.mostrar("As paredes daqui parecem me esmagar um pouco mais a cada dia.")
	await hud.mostrar("Eu só queria passar invisível. Como sempre.")
	await hud.mostrar("Mas tem alguém vindo na minha direção.")
	await hud.mostrar("Meu peito aperta. Por favor, não fala comigo.")
	await hud.mostrar("Olha pro chão.")
	await hud.mostrar("Só continua andando.")
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
	await hud.mostrar("Ela parou bem na minha frente.")
	await hud.mostrar("Minha garganta secou de repente.")
	await hud.mostrar("Eu não sei o que fazer com as minhas mãos.")
	await hud.esconder()

func iniciar_dialogo() -> void:
	dialogo.visible = true
	var falas = [
		{"nome": "Menina Colorida", "texto": "Oi...", "sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")},
		{"nome": "Menina Colorida", "texto": "Qual o seu nome?", "sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")},
		{"nome": "Menina Colorida", "texto": "Você sempre foge assim?", "sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")}
	]
	dialogo.iniciar_dialogo(falas)
	await dialogo.dialogo_finalizado
	await pos_dialogo()

func pos_dialogo() -> void:
	await hud.mostrar("Ela continua ali. Perto demais.")
	await hud.mostrar("Minhas mãos ainda estão tremendo um pouco.")
	await hud.mostrar("Mas... ela não parece estar me julgando.")
	await hud.esconder()
	player.liberar()
	menina.iniciar() 


# ==========================================
# EVENTO FINAL: O ALMOÇO E A ESCOLHA
# ==========================================
func _on_area_almoco_entered(body: Node) -> void:
	if body != player or not encontro or evento_final_rodando:
		return
	evento_final_rodando = true
	await _iniciar_almoco()

func _iniciar_almoco() -> void:
	player.travar()
	menina.parar()
	
	dialogo.visible = true
	
	var falas_iniciais = [
		{"nome": "Menina Colorida", "texto": "Vem, senta aqui. O refeitório lá embaixo está um caos.", "sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")},
		{"nome": "Menina Colorida", "texto": "Você costuma almoçar sozinha sempre?", "sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")}
	]
	
	dialogo.iniciar_dialogo(falas_iniciais)
	await dialogo.dialogo_finalizado
	
	# Prepara a Tela de Escolhas
	label_situacao.text = "Como você responde?"
	label_btn_a.text = "Às vezes... eu só não sei onde sentar."
	label_btn_b.text = "Geralmente sim. Eu prefiro o silêncio."
	menu_escolhas.visible = true 
	
	# Pausa o código e espera o jogador clicar
	var resposta_escolhida = await escolha_feita 
	
	dialogo.visible = true
	if resposta_escolhida == 0:
		# Opção A (Vulnerável)
		var falas_opcao_a = [
			{"nome": "Protagonista", "texto": "Às vezes... eu só não sei onde sentar.", "sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")}, 
			{"nome": "Menina Colorida", "texto": "Bom, agora você sabe. Pode sentar aqui comigo sempre que quiser.", "sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")}
		]
		dialogo.iniciar_dialogo(falas_opcao_a)
		await dialogo.dialogo_finalizado
		GameState.alterar_estado(0, -20, 15, 25, 0)
		
	elif resposta_escolhida == 1:
		# Opção B (Fechada)
		var falas_opcao_b = [
			{"nome": "Protagonista", "texto": "Geralmente sim. Eu prefiro o silêncio.", "sprite": preload("res://assets/sprites/characters/protagonist/portrait/protagonist_portrait.png")}, 
			{"nome": "Menina Colorida", "texto": "Entendo. É bom ter um tempo pra respirar, né? Fica à vontade.", "sprite": preload("res://assets/sprites/characters/colorful_girl/portrait/colorful_girl_portrait.png")}
		]
		dialogo.iniciar_dialogo(falas_opcao_b)
		await dialogo.dialogo_finalizado
		GameState.alterar_estado(-10, -5, 5, 10, 0)
		
	await pos_almoco()

func pos_almoco() -> void:
	await hud.mostrar("Comer perto de alguém é assustador. Fiquei com medo de engasgar.")
	await hud.mostrar("Mas eu consegui. Eu acho.")
	await hud.mostrar("A bateria acabou. Preciso sumir daqui.")
	await hud.esconder()
	
	# Chama o Time Skip logo após os pensamentos terminarem, sem liberar o player
	await iniciar_time_skip()


# ==========================================
# TIME SKIP (TRANSIÇÃO FINAL)
# ==========================================
func iniciar_time_skip() -> void:
	# --- ESCURECE A TELA ---
	await cutscene.play_fade_out(1.0) 
	
	# Frases de hesitação na tela preta (trazendo a ansiedade forte)
	await cutscene.show_text("Será que eu devo mandar mensagem pra ela?", 2.5)
	await cutscene.show_text("Eu tenho tanto medo de estragar tudo...", 2.5)
	await cutscene.show_text("Mas ela que me passou o numero dela.", 2.5)
	await cutscene.show_text("Acho que vou mandar...", 2.0)
	await cutscene.show_text("Não... não sei ainda.", 2.5)
	
	# Pausa dramática no escuro
	await get_tree().create_timer(1.0).timeout
	
	# O grande salto no tempo
	await cutscene.show_text("4 MESES DEPOIS", 3.0)
	
	# Outra pausa curta antes de abrir a nova cena
	await get_tree().create_timer(0.5).timeout
	
	# Vai para a cena do ônibus (ou cena final)
	get_tree().change_scene_to_file("res://scenes/universidade/corredor_colorida_final.tscn")


# ==========================================
# FUNÇÕES DOS BOTÕES (SINAIS)
# ==========================================
func _on_botao_a_pressionado() -> void:
	menu_escolhas.visible = false 
	escolha_feita.emit(0)

func _on_botao_b_pressionado() -> void:
	menu_escolhas.visible = false 
	escolha_feita.emit(1)
