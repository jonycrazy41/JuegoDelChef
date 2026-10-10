extends Node2D

@export var total_coleccionables: int = 5
var coleccionables_recogidos: int = 0
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var puerta: Area2D = $Puerta
@onready var bruno_2: CharacterBody2D = $Bruno2
@onready var carta: Node2D = $IntroLayer/Carta

@export_group("Intro")
@export var duracion_carta: float = 5.0
@export var duracion_fade_in: float = 0.4
@export var duracion_fade_out: float = 1.0

func _ready() -> void:
	puerta.deactivate_door()
	_intro()
func _intro() -> void:

	bruno_2.set_physics_process(false)
	bruno_2.velocity = Vector2.ZERO

	carta.modulate.a = 0.0

	var t_in := create_tween()
	t_in.tween_property(carta, "modulate:a", 1.0, duracion_fade_in)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await t_in.finished

	await get_tree().create_timer(duracion_carta).timeout

	var t_out := create_tween()
	t_out.set_parallel(true)
	t_out.tween_property(carta, "modulate:a", 0.0, duracion_fade_out)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await t_out.finished

	carta.visible = false
	bruno_2.set_physics_process(true)
func registrar_coleccionable() -> void:
	coleccionables_recogidos += 1
	audio_stream_player_2d.play()
	print("Coleccionables: ", coleccionables_recogidos, "/", total_coleccionables)

	if coleccionables_recogidos >= total_coleccionables:
		puerta.activate_door()
		print("¡Puerta abierta! Ya puedes pasar al siguiente nivel.")
