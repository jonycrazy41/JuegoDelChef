extends Area2D

var esta_activa: bool = false
var jugador_cerca: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func deactivate_door() -> void:
	esta_activa = false

func activate_door() -> void:
	esta_activa = true
	print("¡Puerta abierta!")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jugador_cerca = false

func _unhandled_input(event: InputEvent) -> void:
	if not jugador_cerca:
		return
	if event.is_action_pressed("interactuar"):
		if esta_activa:
			get_tree().change_scene_to_file("res://Escenas/nivel2.tscn")
		else:
			print("La puerta está cerrada. ¡Faltan coleccionables!")
