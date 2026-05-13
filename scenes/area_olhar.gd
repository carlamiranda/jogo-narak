extends Area2D

@onready var dialogo = $"../CanvasLayer/CaixaDialogoBanheiro"
@onready var protagonista = $"../Banheiro/Protagonista"
@onready var menina = $"../Banheiro/MeninaBanheiro"

var ativou = false


func _on_body_entered(body):

	if body.name == "Protagonista" and !ativou:

		ativou = true

		protagonista.pode_andar = false
		protagonista.velocity = Vector2.ZERO

		protagonista.anim.play("walk_right")
		protagonista.anim.stop()

		dialogo.iniciar_dialogo([
			{
				"nome":"Protagonista",
				"texto":"!",
				"sprite": preload("res://sprites/personagemprincipal.jpg")
			},
			{
				"nome":"Menina",
				"texto":"...",
				"sprite": preload("res://sprites/meninabanheiro.webp")
			},
			{
				"nome":"Protagonista",
				"texto":"...",
				"sprite": preload("res://sprites/personagemprincipal.jpg")
			}
		], true)

		while dialogo.visible:
			await get_tree().process_frame

		await get_tree().create_timer(0.4).timeout

		menina.destino = menina.global_position + Vector2(0, 100)

		menina.movendo = true

		while menina.movendo:
			await get_tree().process_frame

		await get_tree().create_timer(0.2).timeout

		menina.destino = menina.global_position + Vector2(-900, 0)

		menina.movendo = true

		while menina.movendo:
			await get_tree().process_frame

		menina.queue_free()

		protagonista.anim.play("walk_left")
		protagonista.anim.stop()

		await get_tree().create_timer(1).timeout

		dialogo.iniciar_dialogo([
			{
				"nome":"Protagonista",
				"texto":"Ela tava se escondendo também.",
				"sprite": preload("res://sprites/personagemprincipal.jpg")
			},
			{
				"nome":"Protagonista",
				"texto":"Achei que só eu fazia isso.",
				"sprite": preload("res://sprites/personagemprincipal.jpg")
			},
			{
				"nome":"Protagonista",
				"texto":"Talvez eu consiga voltar amanhã.",
				"sprite": preload("res://sprites/personagemprincipal.jpg")
			}
		], true)

		while dialogo.visible:
			await get_tree().process_frame

		await get_tree().create_timer(0.5).timeout

		protagonista.andando_automatico = true

		protagonista.destino = protagonista.global_position + Vector2(-900, 0)
