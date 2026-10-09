extends CharacterBody2D

const SPEED = 200

@onready var sprite: AnimatedSprite2D = Sprite2D

func _physics_process(delta: float) -> void:process
	velocity.x = direction * SPEED
	velocity.y = 0.0
	move_and_slide()
