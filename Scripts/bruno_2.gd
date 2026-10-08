extends CharacterBody2D

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
	
func morir():
	get_tree().quit()
