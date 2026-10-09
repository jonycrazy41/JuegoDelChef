extends Control

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/nivel.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/nivel_plataformero.tscn")


func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/nivel2.tscn")
