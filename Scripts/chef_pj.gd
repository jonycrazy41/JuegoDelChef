extends CharacterBody2D
#hola profe soy Jonathan Alame
const SPEED = 200.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED
	move_and_slide()
	
	if direction == Vector2.ZERO:
		if sprite.animation != "IdleAnimation":
			sprite.play("IdleAnimation")
	else:
		if sprite.animation != "RunAnimation":
			sprite.play("RunAnimation")
	
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if Input.is_action_just_pressed("ClickIzquierdo"):
		pass

func morir():
	get_tree().quit()
