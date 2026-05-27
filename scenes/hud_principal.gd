extends CanvasLayer

@onready var c1 = $MarginContainer/Coracoes/C1
@onready var c2 = $MarginContainer/Coracoes/C2
@onready var c3 = $MarginContainer/Coracoes/C3
@onready var c4 = $MarginContainer/Coracoes/C4

var vidas_maximas = 4
var vidas_atuais = 4

func _ready():
	# Garante que todos os corações estão visíveis no início
	c1.visible = true
	c2.visible = true
	c3.visible = true
	c4.visible = true

func tomar_dano():
	if vidas_atuais > 0:
		vidas_atuais -= 1
		_atualizar_coracoes()
		
		if vidas_atuais <= 0:
			print("Pânico Total! (Game Over)")
			# Aqui futuramente você chama a tela de reinício

func curar_dano():
	if vidas_atuais < vidas_maximas:
		vidas_atuais += 1
		_atualizar_coracoes()

# Função que liga/desliga as imagens dependendo do número de vidas
func _atualizar_coracoes():
	c4.visible = vidas_atuais >= 4
	c3.visible = vidas_atuais >= 3
	c2.visible = vidas_atuais >= 2
	c1.visible = vidas_atuais >= 1
