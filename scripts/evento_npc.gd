extends Area2D

# Falas da primeira interação
@export var falas_do_npc: Array[String] = [
	"Boa tarde, aqui está seu panfleto.",
	"Olhe com bastante atenção seus horários de aula.",
	"Boa sorte nessa sua nova fase."
]

# Fala de quando o jogador tentar interagir de novo
@export var fala_repetida: String = "Se tiver mais alguma pergunta, pode falar com a coordenação do seu curso."

var jogador_perto := false
var ja_entregou := false
var interagindo := false

func _ready():
	# Conecta os sinais de entrada e saída da área azul
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Protagonista" and not interagindo:
		jogador_perto = true
		_mostrar_dica()

func _on_body_exited(body):
	if body.name == "Protagonista":
		jogador_perto = false
		
		# Esconde a dica de apertar o botão quando ela vai embora
		var hud_texto = get_tree().current_scene.get_node_or_null("HudCorredor")
		if hud_texto and not interagindo:
			hud_texto.hide_message()

func _input(event):
	# Usa a tecla "interagir" (ou "ui_accept" se preferir usar Espaço/Enter padrão)
	if event.is_action_pressed("interagir"):
		
		# Só funciona se estiver perto e não estiver no meio de um papo
		if jogador_perto and not interagindo:
			iniciar_dialogo()

func iniciar_dialogo():
	interagindo = true 
	
	var hud_texto = get_tree().current_scene.get_node_or_null("HudCorredor")
	var hud_vida = get_tree().current_scene.get_node_or_null("HudPrincipal")
	
	if hud_texto:
		# PRIMEIRA VEZ: Toca o diálogo longo e entrega o item
		if not ja_entregou:
			for fala in falas_do_npc:
				hud_texto.show_message(fala)
				await hud_texto.avancar_dialogo 
			
			# Acende o ícone na HUD
			if hud_vida:
				hud_vida.receber_anotacao()
				
			hud_texto.show_message("*(Você pegou a anotação! Clique no ícone para ver)*")
			await hud_texto.avancar_dialogo
			
			ja_entregou = true # Marca que já pegou o item
			
		# SEGUNDA VEZ EM DIANTE: Toca apenas a fala curta
		else:
			hud_texto.show_message(fala_repetida)
			await hud_texto.avancar_dialogo
			
		# Ao terminar qualquer um dos diálogos, esconde a caixa de texto
		await hud_texto.hide_message()
		
	interagindo = false
	
	# Se a protagonista ainda estiver na área após o diálogo, mostra a dica de novo
	if jogador_perto:
		_mostrar_dica()

# Função auxiliar para não repetir código
func _mostrar_dica():
	var hud_texto = get_tree().current_scene.get_node_or_null("HudCorredor")
	if hud_texto:
		hud_texto.show_message("Falar com o atendente (Aperte E)")
