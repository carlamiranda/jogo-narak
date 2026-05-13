extends Node2D

@onready var label_debug: Label = $CanvasLayer/Panel/VBoxContainer/LabelDebug
@onready var button_ansiedade: Button = $CanvasLayer/Panel/VBoxContainer/Button_Ansiedade
@onready var button_isolamento: Button = $CanvasLayer/Panel/VBoxContainer/Button_Isolamento
@onready var button_confianca: Button = $CanvasLayer/Panel/VBoxContainer/Button_Confianca
@onready var button_resetar: Button = $CanvasLayer/Panel/VBoxContainer/Button_Resetar


# Conecta os botões de teste
func _ready() -> void:
	button_ansiedade.pressed.connect(aumentar_ansiedade)
	button_isolamento.pressed.connect(aumentar_isolamento)
	button_confianca.pressed.connect(aumentar_confianca)
	button_resetar.pressed.connect(resetar_emocoes)

	atualizar_debug()


# Atualiza o texto com os valores atuais
func atualizar_debug() -> void:
	label_debug.text = (
		"Ansiedade: " + str(GameState.ansiedade) + "\n" +
		"Isolamento: " + str(GameState.isolamento) + "\n" +
		"Confiança: " + str(GameState.confianca) + "\n" +
		"Rota: " + GameState.rota_atual
	)


# Testa o tremor da tela
func aumentar_ansiedade() -> void:
	GameState.ansiedade = clamp(GameState.ansiedade + 15, 0, 100)
	atualizar_debug()


# Testa o escurecimento/frieza
func aumentar_isolamento() -> void:
	GameState.rota_atual = "espelho"
	GameState.isolamento = clamp(GameState.isolamento + 15, 0, 100)
	atualizar_debug()


# Testa o clareamento da rota positiva
func aumentar_confianca() -> void:
	GameState.rota_atual = "colorida"
	GameState.confianca = clamp(GameState.confianca + 15, 0, 100)
	atualizar_debug()


# Volta tudo ao padrão
func resetar_emocoes() -> void:
	GameState.resetar_jogo()
	atualizar_debug()
