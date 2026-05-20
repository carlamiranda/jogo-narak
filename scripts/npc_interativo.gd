extends Node2D

@export var fala_npc: String = "Ela parece meio perdida..."
@export var tempo_balao: float = 3.0
@export var repetir_fala: bool = false

@onready var area_interacao: Area2D = $AreaInteracao

var balao: Node2D
var ja_falou := false


func _ready() -> void:
	if area_interacao == null:
		print("ERRO: AreaInteracao não encontrada em ", name)
		return

	# Procura o balão direto dentro do NPC
	balao = get_node_or_null("NpcBalao")

	# Se não achar, procura dentro do BalaoHolder
	if balao == null:
		balao = get_node_or_null("BalaoHolder/NpcBalao")

	if balao == null:
		print("ERRO: NpcBalao não encontrado em ", name)
	else:
		balao.visible = false
		balao.z_index = 100

	area_interacao.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.name != "Protagonista":
		return

	if ja_falou and not repetir_fala:
		return

	ja_falou = true

	print("NPC falou: ", fala_npc)

	if balao == null:
		print("ERRO: Balão está null")
		return

	if balao.has_method("mostrar_fala"):
		balao.mostrar_fala(fala_npc, tempo_balao)
	else:
		print("ERRO: O balão não tem o método mostrar_fala.")
