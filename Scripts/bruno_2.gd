extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300
const JUMP_VELOCITY = 500

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Saltar"):
		velocity.y -= JUMP_VELOCITY
	var direction := Input.get_axis("izquierda", "derecha")
	velocity.x = direction * SPEED
	move_and_slide()
	
	if direction == 0.0:
		if sprite.animation != "IdleAnimation":
			sprite.play("IdleAnimation")
	else:
		if sprite.animation != "RunAnimation":
			sprite.play("RunAnimation")
	
	if direction < 0:
		sprite.flip_h = true
	elif direction > 0:
		sprite.flip_h = false
	
func morir():
	get_tree().quit()
