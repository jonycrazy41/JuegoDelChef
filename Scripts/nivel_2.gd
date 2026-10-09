extends Node2D

var cucarachas_restantes: int = 0
signal todas_muertas

@onready var camara: Camera2D = $Bruno/Camera2D
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

@export_group("Zoom de entrada")
@export var zoominicial: Vector2 = Vector2(2.0, 2.0)   # más grande = más zoom in
@export var zoomfinal: Vector2 = Vector2(1.0, 1.0)     # zoom normal
@export var duracionzoom: float = 1.2

@export_group("Fade de entrada")
@export var duracionfade: float = 1.0
@export var delayfade: float = 0.15                    # pequeño delay antes de aclarar

func _ready() -> void:
	# Estado inicial: cámara con zoom in + pantalla negra
	camara.zoom = zoominicial
	color_rect.color = Color(0, 0, 0, 1)
	await get_tree().create_timer(0.4).timeout

	# Tween paralelo: hace las dos cosas al mismo tiempo
	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(camara, "zoom", zoomfinal, duracionzoom)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(color_rect, "color:a", 0.0, duracionfade)\
		.set_delay(delayfade)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	var cucarachas := get_tree().get_nodes_in_group("cucarachas")
	cucarachas_restantes = cucarachas.size()
	print("Cucarachas al inicio: ", cucarachas_restantes)
	for c in cucarachas:
		c.muriosenial.connect(_on_cucaracha_muerta)

func _on_cucaracha_muerta() -> void:
	cucarachas_restantes -= 1
	print("Quedan: ", cucarachas_restantes)

	if cucarachas_restantes <= 0:
		todas_muertas.emit()
		print("¡Todas muertas! Ya podés cocinar.")
