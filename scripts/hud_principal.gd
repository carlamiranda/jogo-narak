extends CanvasLayer

@onready var margin_container = $MarginContainer
@onready var c1 = $MarginContainer/Coracoes/C1
@onready var c2 = $MarginContainer/Coracoes/C2
@onready var c3 = $MarginContainer/Coracoes/C3
@onready var c4 = $MarginContainer/Coracoes/C4
@onready var tela_escura = $TelaEscura

# --- NOVA REFERÊNCIA AO TEXTO DA MORTE ---
@onready var texto_morte = get_node_or_null("TextoMorte")

# Só precisamos do botão e do pop-up agora
@onready var botao_papel = $MarginContainer/Coletaveis/BotaoPapel
@onready var popup_leitura = $PopupLeitura

var vidas_maximas = 4
var vidas_atuais = 4
var tem_papel = false

func _ready():
	# Esconde tudo no começo
	if margin_container:
		margin_container.visible = false
		
	if tela_escura:
		tela_escura.modulate.a = 0.0
		
	# Esconde o texto da morte no início
	if texto_morte:
		texto_morte.modulate.a = 0.0
		
	c1.visible = true
	c2.visible = true
	c3.visible = true
	c4.visible = true
	
	if botao_papel:
		botao_papel.modulate.a = 0.3
		botao_papel.disabled = true
	if popup_leitura:
		popup_leitura.visible = false

# Chamada pelo mapa para mostrar os corações após cutscene
func mostrar_hud():
	if margin_container:
		margin_container.visible = true

# ==================== SISTEMA DE VIDA ====================
func tomar_dano():
	if vidas_atuais > 0:
		vidas_atuais -= 1
		_atualizar_coracoes()
		
		GameState.alterar_estado(15, 5, -5, 0, 0)
		
		if vidas_atuais <= 0:
			_game_over()

func curar_dano():
	if vidas_atuais < vidas_maximas:
		vidas_atuais += 1
		_atualizar_coracoes()

func _atualizar_coracoes():
	c4.visible = vidas_atuais >= 4
	c3.visible = vidas_atuais >= 3
	c2.visible = vidas_atuais >= 2
	c1.visible = vidas_atuais >= 1

# ==================== NOVA ANIMAÇÃO DE MORTE ====================
func _game_over():
	GameState.ja_tentou_fase_1 = true
	
	# 1. Congela o jogador completamente no lugar
	var protagonista = get_tree().current_scene.get_node_or_null("Protagonista")
	if protagonista:
		protagonista.set_physics_process(false)
		
		# Zera a inércia/movimento
		if "velocity" in protagonista:
			protagonista.velocity = Vector2.ZERO 
			
		# Congela a animação dela
		var anim_prota = protagonista.get_node_or_null("AnimatedSprite2D")
		if anim_prota:
			anim_prota.stop() 
		
	if margin_container:
		margin_container.visible = false 
	
	# 2. Joga a ansiedade no máximo para o EmotionVisualController tremer a tela com força!
	GameState.ansiedade = 100
	
	# 3. Escurece a tela LENTAMENTE (3 segundos) enquanto a tela treme
	if tela_escura:
		var tween_tela = create_tween()
		tween_tela.tween_property(tela_escura, "modulate:a", 1.0, 3.0)
		await tween_tela.finished
	
	# 4. Faz o texto "Eu preciso me acalmar..." aparecer suavemente (1.5 segundos)
	if texto_morte:
		var tween_texto = create_tween()
		tween_texto.tween_property(texto_morte, "modulate:a", 1.0, 1.5)
		await tween_texto.finished
	
	# 5. Pausa dramática para o jogador ler a frase (2 segundos)
	await get_tree().create_timer(2.0).timeout
	
	# 6. Só agora volta os status ao normal para o reinício
	GameState.ansiedade = 50
	GameState.isolamento = 50
	GameState.confianca = 0
	
	# 7. Reinicia a fase
	get_tree().reload_current_scene()

# ==================== SISTEMA DE COLETÁVEIS ====================
func receber_anotacao():
	tem_papel = true
	if botao_papel:
		botao_papel.modulate.a = 1.0 
		botao_papel.disabled = false 

func _on_botao_papel_pressed():
	if tem_papel and popup_leitura:
		popup_leitura.visible = true
		get_tree().paused = true

func _on_botao_fechar_pressed():
	if popup_leitura:
		popup_leitura.visible = false
		get_tree().paused = false

func _on_button_pressed() -> void:
	pass
