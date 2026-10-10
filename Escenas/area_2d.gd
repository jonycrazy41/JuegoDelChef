extends Area2D

var esta_activa: bool = false

func deactivate_door() -> void:
	esta_activa = false
	$CollisionShape2D.disabled = true 

func activate_door() -> void:
	esta_activa = true
	$CollisionShape2D.disabled = false
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Bruno2":
		if esta_activa:
			get_tree().change_scene_to_file("res://Escenas/nivel2.tscn")
		else:
			print("La puerta está cerrada. ¡Faltan coleccionables!")
