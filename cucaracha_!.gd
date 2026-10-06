extends CharacterBody2D

@export var speed: float = 100.0
var direction: int = 1

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(_delta: float) -> void:
	if is_on_wall():
		flip()

	velocity.x = direction * speed
	velocity.y = 0.0

	move_and_slide()

func flip() -> void:
	direction *= -1
	# Voltea solo la imagen, sin modificar el cuerpo ni la colisión
	sprite.flip_h = (direction < 0)
