extends Node2D

@export var total_coleccionables: int = 5
var coleccionables_recogidos: int = 0

@onready var puerta = $Puerta

func _ready() -> void:
	
	puerta.deactivate_door() 

func registrar_coleccionable() -> void:
	coleccionables_recogidos += 1
	print("Coleccionables: ", coleccionables_recogidos, "/", total_coleccionables)
	
	if coleccionables_recogidos >= total_coleccionables:
		puerta.activate_door() 
		print("¡Puerta abierta! Ya puedes pasar al siguiente nivel.")
