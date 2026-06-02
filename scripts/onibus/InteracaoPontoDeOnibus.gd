extends Node2D

@export var texto_prompt: String = "Pressione E para interagir"
@export var repetir_interacao: bool = false

@onready var area_interacao: Area2D = $AreaInteracao

var balao: Node2D
var jogador_perto := false
var ja_interagiu := false
var sequencia_em_andamento := false


func _ready() -> void:
	if area_interacao == null:
		push_error("AreaInteracao não encontrada em %s" % name)
		return

	balao = _encontrar_balao()

	if balao == null:
		push_error("Balão de interação não encontrado em %s" % name)
	else:
		balao.visible = false
		balao.z_index = 100

	area_interacao.body_entered.connect(_on_body_entered)
	area_interacao.body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if not jogador_perto or sequencia_em_andamento:
		return

	if not Input.is_action_just_pressed("interagir"):
		return

	if ja_interagiu and not repetir_interacao:
		return

	ja_interagiu = true
	_executar_confirmacao()


func _encontrar_balao() -> Node2D:
	for caminho in ["cenadoonibus", "PopupAnimacao", "NpcBalao", "BalaoHolder/PopupAnimacao", "BalaoHolder/NpcBalao"]:
		var no := get_node_or_null(caminho) as Node2D
		if no != null:
			return no
	return null


func _obter_cena_raiz() -> Node:
	return get_parent()


func _eh_protagonista(body: Node) -> bool:
	return body is CharacterBody2D and body.name == "Protagonista"


func _mostrar_prompt() -> void:
	if balao == null:
		return

	if balao.has_method("mostrar_prompt_interacao"):
		balao.mostrar_prompt_interacao(texto_prompt)
	elif balao.has_method("mostrar_fala"):
		balao.mostrar_fala(texto_prompt, 999.0)


func _esconder_balao() -> void:
	if balao != null and balao.has_method("esconder"):
		balao.esconder()


func _executar_confirmacao() -> void:
	sequencia_em_andamento = true
	_esconder_balao()

	var cena := _obter_cena_raiz()

	if cena != null and cena.has_method("iniciar_embarque_onibus"):
		await cena.iniciar_embarque_onibus()
	else:
		push_error("Script ponto_de_onibus.gd não encontrado na raiz da cena.")
		await Cutscene.play_fade_out(1.0)

	sequencia_em_andamento = false


func _on_body_entered(body: Node) -> void:
	if not _eh_protagonista(body) or sequencia_em_andamento:
		return

	jogador_perto = true
	_mostrar_prompt()


func _on_body_exited(body: Node) -> void:
	if not _eh_protagonista(body):
		return

	jogador_perto = false

	if sequencia_em_andamento:
		return

	_esconder_balao()

	if repetir_interacao:
		ja_interagiu = false
