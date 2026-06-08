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
	# Trava o movimento inicial para a cutscene
	protagonista.set_physics_process(false)
	protagonista.velocity = Vector2.ZERO
	protagonista.get_node("AnimatedSprite2D").stop()

	# Conexões de sinais
	area_saida.body_entered.connect(_on_saida_entered)
	
	# Verifica se a EncontroArea existe antes de conectar
	var area_encontro = menina.get_node_or_null("EncontroArea")
	if area_encontro:
		area_encontro.body_entered.connect(_on_encontro_entered)

	# Inicia a sequência automática
	await mover_ate_espelho()

func mover_ate_espelho() -> void:
	# Move o personagem automaticamente até o espelho
	while protagonista.global_position.distance_to(espelho.global_position) > 20:
		var dir: Vector2 = (espelho.global_position - protagonista.global_position).normalized()
		protagonista.velocity = dir * 120
		protagonista.move_and_slide()
		await get_tree().physics_frame

	protagonista.velocity = Vector2.ZERO
	protagonista.get_node("AnimatedSprite2D").stop()
	await cutscene_espelho()

func cutscene_espelho() -> void:
	await hud.show_message("Água fria... eu só preciso de água fria no rosto.")
	await hud.avancar_dialogo
	await hud.show_message("Cinco coisas... cinco coisas... Preciso focar.")
	await hud.avancar_dialogo
	await hud.hide_message()
	
	# Libera o controle do jogador
	protagonista.set_physics_process(true)
	investigando = true

func _on_encontro_entered(body: Node) -> void:
	if body != protagonista or not investigando or encontro_feito: return
	encontro_feito = true
	
	protagonista.set_physics_process(false)
	protagonista.velocity = Vector2.ZERO
	protagonista.get_node("AnimatedSprite2D").stop()

	await hud.show_message("Você dá um passo para trás e percebe uma presença.")
	await hud.avancar_dialogo
	await hud.show_message("Tem uma garota te encarando no canto escuro do banheiro.")
	await hud.avancar_dialogo
	await hud.show_message("O susto faz suas mãos tremerem. Alguma coisa cai do seu bolso.")
	await hud.avancar_dialogo
	await hud.show_message("O dia já deu por hoje. O ônibus parece ser o único refúgio agora.")
	await hud.avancar_dialogo
	await hud.hide_message()
	
	protagonista.set_physics_process(true)

func _on_saida_entered(body: Node) -> void:
	if body != protagonista or not investigando or evento_finalizado: return
	
	if not encontro_feito:
		protagonista.set_physics_process(false)
		await hud.show_message("Tem alguém ali no canto... não consigo ir embora sem ver quem é.")
		await hud.avancar_dialogo
		await hud.hide_message()
		# Dá um empurrãozinho para trás para o jogador não ficar travado na porta
		protagonista.global_position.y += 15 
		protagonista.set_physics_process(true)
		return

	evento_finalizado = true
	await ir_para_onibus()

func ir_para_onibus() -> void:
	protagonista.set_physics_process(false)
	await hud.show_message("Você decide cruzar a porta e sair dali o mais rápido possível.")
	await hud.avancar_dialogo
	await hud.hide_message()
	get_tree().change_scene_to_file("res://scenes/onibus/PontoDeOnibus.tscn")
