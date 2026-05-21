extends Node2D

@onready var protagonista = $Protagonista
@onready var espelho = $EspelhoBanheiro
@onready var hud = $HudBanheiro
@onready var area_box = $AreaBox
@onready var porta_fechada = $AreaBox/PortaFechada

var chegou_espelho := false
var cutscene_rodando := false
var investigando := false
var trancada_no_box := false

func _ready():
	protagonista.pode_andar = false
	protagonista.andando_automatico = true
	protagonista.destino = espelho.global_position
	area_box.body_entered.connect(_on_area_box_body_entered)

func _physics_process(_delta):
	if chegou_espelho or cutscene_rodando:
		return

	if protagonista.global_position.distance_to(espelho.global_position) <= 20:
		chegou_espelho = true
		cutscene_rodando = true

		protagonista.andando_automatico = false
		protagonista.velocity = Vector2.ZERO
		protagonista.anim.play("walk_up")

		call_deferred("_start_cutscene")

func _start_cutscene():
	await _cutscene_espelho()

func _cutscene_espelho():
	protagonista.velocity = Vector2.ZERO

	var falas = [
		"Água fria. Eu só preciso de água fria no rosto.",
		"Cinco coisas... 
		Cinco coisas...",
		"preciso focar em cinco coisas. O espelho, a pia, a luz...",
		"AAAA o zumbido dessa lâmpada está me deixando pior..",
		"CALMA!", 
		"Você está segura aqui. Ninguém vai entrar.",
		"Ninguém vai entrar!"
	]
	

	for fala in falas:
		hud.show_message(fala)
		await hud.avancar_dialogo 
		
	await hud.hide_message()

	protagonista.pode_andar = true
	investigando = true
	cutscene_rodando = false
	
func _on_area_box_body_entered(body):
	if body == protagonista and investigando and not trancada_no_box:
		trancada_no_box = true
		fechar_porta_do_box()

func fechar_porta_do_box():
	porta_fechada.visible = true
	
	protagonista.get_node("AnimatedSprite2D").visible = false
	
	protagonista.velocity = Vector2.ZERO
	protagonista.pode_andar = false
	
	await get_tree().create_timer(1.0).timeout 
	
	await hud.show_message("Pronto... ninguém vai me ver aqui.")
	await hud.avancar_dialogo
	await hud.show_message("É só esperar passar.")
	await hud.avancar_dialogo
	await hud.hide_message()
