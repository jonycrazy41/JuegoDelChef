extends Node2D

@onready var label: Label = $Label
@export var intervalo: float = 5.0

var mensajes: PackedStringArray = [
	"Al final Bruno le dio las pepas a su jefe Pepe",
	"Un juego por:\n\nAlame Jonathan\n\nBauer Santiago\n\nQuiroga Martina",
	"Agradecimientos especiales a:\n\nLuka (hizo un sonido)\n\nY\n\nBruno (Nuestro chef de confianza)",
	"Fin"
]

func _ready() -> void:
	label.text = mensajes[0]
	_mostrar_mensajes()

func _mostrar_mensajes() -> void:
	for i in range(1, mensajes.size()):
		await get_tree().create_timer(intervalo).timeout
		label.text = mensajes[i]
