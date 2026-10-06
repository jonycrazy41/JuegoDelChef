extends CharacterBody2D

const danioquerecibe: int = 25

@export var speed: float = 100.0
var direction: int = 1
var salud: int = 50
var murio: bool = false

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(_delta: float) -> void:
	if murio:
		return
	
	if is_on_wall():
		flip()

	velocity.x = direction * speed
	velocity.y = 0.0

	move_and_slide()

func recibir_golpe(danio: int = danioquerecibe):
	if murio:
		return
	
	salud -= danio
	if salud <= 0:
		morir()

func flip() -> void:
	direction *= -1
	# Voltea solo la imagen, sin modificar el cuerpo ni la colisión
	sprite.flip_h = (direction < 0)

func morir():
	murio = true
	await get_tree().create_timer(0.05).timeout
	queue_free()
