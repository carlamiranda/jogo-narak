extends Node2D

@onready var protagonista = $Protagonista
@onready var espelho = $EspelhoBanheiro
@onready var hud = $HudBanheiro
@onready var area_saida = $SaidaOnibus
@onready var menina = $MeninaQuebrada

var investigando := false
var encontro_feito := false
var evento_finalizado := false


func _ready() -> void:
	protagonista.set_physics_process(false)
	protagonista.velocity = Vector2.ZERO
	protagonista.get_node("AnimatedSprite2D").stop()

	area_saida.body_entered.connect(_on_saida_entered)
	
	var area_encontro = menina.get_node_or_null("EncontroArea")
	if area_encontro:
		area_encontro.body_entered.connect(_on_encontro_entered)

	await mover_ate_espelho()


# =========================
# 1. MOVIMENTO AUTOMÁTICO
# =========================
func mover_ate_espelho() -> void:
	while protagonista.global_position.distance_to(espelho.global_position) > 20:
		var dir: Vector2 = (espelho.global_position - protagonista.global_position).normalized()
		protagonista.velocity = dir * 120
		protagonista.move_and_slide()
		await get_tree().physics_frame

	protagonista.velocity = Vector2.ZERO
	protagonista.get_node("AnimatedSprite2D").stop()

	await cutscene_espelho()


# =========================
# 2. CUTSCENE DA PIA (CRISE)
# =========================
func cutscene_espelho() -> void:
	await hud.show_message("Água fria... eu só preciso de água fria no rosto.")
	await hud.avancar_dialogo

	await hud.show_message("Cinco coisas... cinco coisas... Preciso focar.")
	await hud.avancar_dialogo

	await hud.hide_message()

	protagonista.set_physics_process(true)
	investigando = true


# =========================
# 3. APROXIMAÇÃO DA MENINA (SUSTO E VONTADE DE FUGIR)
# =========================
func _on_encontro_entered(body: Node) -> void:
	if body != protagonista or not investigando or encontro_feito:
		return
		
	encontro_feito = true
	
	protagonista.set_physics_process(false)
	protagonista.velocity = Vector2.ZERO
	protagonista.get_node("AnimatedSprite2D").stop()

	await hud.show_message("Você dá um passo para trás e percebe uma presença.")
	await hud.avancar_dialogo

	await hud.show_message("Tem uma garota te encarando no canto escuro do banheiro.")
	await hud.avancar_dialogo

	await hud.show_message("O susto faz suas mãos tremerem. Alguma coisa cai do seu bolso e bate no chão.")
	await hud.avancar_dialogo

	await hud.show_message("O barulho ecoa no azulejo, mas você não tem coragem de se abaixar para pegar.")
	await hud.avancar_dialogo

	# NOVO: O pensamento do ônibus entra engatilhado pelo susto
	await hud.show_message("O dia já deu por hoje. O ônibus parece ser o único refúgio agora.")
	await hud.avancar_dialogo

	await hud.hide_message()

	protagonista.set_physics_process(true)


# =========================
# 4. TENTATIVA DE SAÍDA E FIM DO DIA
# =========================
func _on_saida_entered(body: Node) -> void:
	if body != protagonista or not investigando or evento_finalizado:
		return
		
	if not encontro_feito:
		protagonista.set_physics_process(false)
		protagonista.velocity = Vector2.ZERO
		protagonista.get_node("AnimatedSprite2D").stop()
		
		await hud.show_message("Tem alguém ali no canto... não consigo simplesmente ir embora sem ver quem é.")
		await hud.avancar_dialogo
		await hud.hide_message()
		
		protagonista.global_position.y += 15 
		protagonista.set_physics_process(true)
		return

	evento_finalizado = true
	await ir_para_onibus()


func ir_para_onibus() -> void:
	protagonista.set_physics_process(false)
	protagonista.velocity = Vector2.ZERO
	protagonista.get_node("AnimatedSprite2D").stop()

	# Confirmação final antes de trocar de cena
	await hud.show_message("Você decide cruzar a porta e sair dali o mais rápido possível.")
	await hud.avancar_dialogo
	await hud.hide_message()

	get_tree().change_scene_to_file("res://scenes/onibus/PontoDeOnibus.tscn")
