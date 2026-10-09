extends CharacterBody2D

const SPEED = 200
var direction = 1

@onready var sprite: AnimatedSprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	if position.x > 500:
		direction = -1
	elif position.x < 100:
		direction = 1
	velocity.x = direction * SPEED
	velocity.y = 0.0
	move_and_slide()
	sprite.play("RataCamina")
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false
 
