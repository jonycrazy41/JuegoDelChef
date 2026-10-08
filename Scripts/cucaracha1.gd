extends CharacterBody2D

# Velocidad de movimiento
@export var speed: float = 100.0

# Dirección inicial: 1 para derecha, -1 para izquierda
var direction: int = 1

@onready var sprite: Sprite2D = $Sprite2D
@onready var ray_cast: RayCast2D = $RayCast2D

func _physics_process(_delta: float) -> void:
	# Si choca contra una pared o el RayCast detecta un obstáculo, cambia de dirección
	if is_on_wall() or ray_cast.is_colliding():
		flip()

	# Establecer la velocidad horizontal únicamente
	velocity.x = direction * speed
	velocity.y = 0.0

	# Mover el cuerpo y procesar colisiones
	move_and_slide()

# Función para dar la vuelta al sprite y al detector
func flip() -> void:
	direction *= -1
	sprite.flip_h = (direction < 0) # Invierte la imagen horizontalmente
	ray_cast.target_position.x *= -1 # Invierte la dirección del RayCast
