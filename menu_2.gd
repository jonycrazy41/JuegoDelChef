extends Control

func _on_nivel_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/nivel_plataformero.tscn")

func _on_salir_pressed() -> void:
	get_tree().quit()
	
