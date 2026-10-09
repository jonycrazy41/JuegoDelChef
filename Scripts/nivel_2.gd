extends Node2D

var cucarachas_restantes: int = 0
signal todas_muertas

@onready var camara: Camera2D = $Bruno/Camera2D
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var bruno: CharacterBody2D = $Bruno
@onready var horno: RigidBody2D = $horno
@export var escena_final: String = "uid://dgik7s7t1a837"
@export var paquete_pepas: PackedScene = preload("uid://cu0i68tgebukc")
var paquete_escala: Vector2 = Vector2(0.5, 0.5)

@export var zoominicial: Vector2 = Vector2(2.0, 2.0)
@export var zoomfinal: Vector2 = Vector2(1.0, 1.0)
@export var duracionzoom: float = 1.2
@export var duracionfade: float = 1.0
@export var delayfade: float = 0.15

@export_group("Fatality")
@export_range(0.0, 1.0) var probabilidad_fatality: float = 0.10
@export var fatality_zoom: Vector2 = Vector2(3.5, 3.5)
@export var fatality_duracion_in: float = 0.25
@export var fatality_hold: float = 0.60
@export var fatality_duracion_out: float = 0.25
@export_range(0.05, 1.0) var fatality_time_scale: float = 0.25
var fatality_activa: bool = false

func _ready() -> void:
	camara.zoom = zoominicial
	color_rect.color = Color(0, 0, 0, 1)
	await get_tree().create_timer(0.4).timeout

	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(camara, "zoom", zoomfinal, duracionzoom)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	tween.tween_property(color_rect, "color:a", 0.0, duracionfade)\
		.set_delay(delayfade)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	var cucarachas := get_tree().get_nodes_in_group("cucarachas")
	cucarachas_restantes = cucarachas.size()
	print("Cucarachas al inicio: ", cucarachas_restantes)
	for c in cucarachas:
		c.muriosenial.connect(_on_cucaracha_muerta)
	
	horno.horno_encendido.connect(_secuencia_final)

func _on_cucaracha_muerta(pos_muerte: Vector2) -> void:
	cucarachas_restantes -= 1

	var es_ultima := cucarachas_restantes <= 0

	if es_ultima:
		todas_muertas.emit()

	if fatality_activa:
		return

	var disparar := es_ultima or randf() < probabilidad_fatality
	if disparar:
		_fatalitie(pos_muerte)

func _fatalitie(_pos_enemigo: Vector2) -> void:
	fatality_activa = true
	bruno.EntraEnFatality()

	Engine.time_scale = fatality_time_scale

	var t := create_tween()
	t.tween_property(camara, "zoom", fatality_zoom, fatality_duracion_in)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	await t.finished
	await get_tree().create_timer(fatality_hold).timeout
	
	Engine.time_scale = 1.0
	
	var t2 := create_tween()
	t2.tween_property(camara, "zoom", zoomfinal, fatality_duracion_out)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

	await t2.finished
	bruno.SaledeFatality()
	fatality_activa = false

func _secuencia_final() -> void:
	# 1. Congelar al jugador (reutilizamos EntraEnFatality)
	bruno.EntraEnFatality()

	# 2. Zoom in + pan hacia el horno
	var offset_horno := horno.global_position - bruno.global_position
	var t_zoom := create_tween()
	t_zoom.set_parallel(true)
	t_zoom.tween_property(camara, "zoom", Vector2(2.5, 2.5), 0.8)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t_zoom.tween_property(camara, "offset", offset_horno, 0.8)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await t_zoom.finished

	# 3. Esperar 7 segundos con el horno "cocinando"
	await get_tree().create_timer(7.0).timeout

	# 4. Sale el paquete de pepas con popup
	var paquete := paquete_pepas.instantiate()
	get_tree().current_scene.add_child(paquete)
	paquete.global_position = horno.global_position + Vector2(0, -40)
	paquete.scale = Vector2.ZERO

	var t_pop := create_tween()
	t_pop.tween_property(paquete, "scale", paquete_escala, 0.5)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# 5. Esperar 6 segundos
	await get_tree().create_timer(6.0).timeout

	# 6. Fade to black
	var t_fade := create_tween()
	t_fade.tween_property(color_rect, "color:a", 1.0, 1.0)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await t_fade.finished

	# 7. Cambiar de escena
	get_tree().change_scene_to_file(escena_final)
