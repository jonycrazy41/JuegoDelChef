extends CharacterBody2D
#hola profe soy Jonathan Alame
const SPEED = 200.0
const DuracionAtaque = 0.25
const AnguloSarten1 = 70.0
const AnguloSarten2 = -10.0
const MangoOffset = 6

@onready var camara: Camera2D = $Camera2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sarten: Sprite2D = $Sarten
@onready var hitbox: Area2D = $Sarten/Hitbox
@onready var sonidoataque: AudioStreamPlayer = $SonidoAtaque

var EstaAtacanddo = false
var miraaladerecha = false

func _ready() -> void:
	sarten.visible = false
	hitbox.monitoring = false
	hitbox.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(float) -> void:
	var direction := Input.get_vector("izquierda", "derecha", "Arriba", "Abajo")
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
		miraaladerecha = false
	else:
		sprite.flip_h = false
		miraaladerecha = true
	
	if Input.is_action_just_pressed("ClickIzquierdo") and not EstaAtacanddo:
		ataque()

func ataque():
	EstaAtacanddo = true
	sarten.visible = true
	hitbox.monitoring = true
	
	sonidoataque.pitch_scale = randf_range(0.90, 1.1)
	sonidoataque.play()
	
	var side = -1.0 if miraaladerecha else 1.0
	sarten.position = Vector2(-9 * side, 5)
	sarten.scale.x = side #para girar el sprite manteniendo su escala
	sarten.rotation_degrees = AnguloSarten1 * side
	
	var tween := create_tween()
	tween.tween_property(sarten, "rotation_degrees",
			AnguloSarten2 * side, DuracionAtaque)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(terminarAtaque)
	
	await tween.finished
	var temblor := create_tween()
	temblor.tween_property(camara, "offset", Vector2(2, -2), 0.02)
	temblor.tween_property(camara, "offset", Vector2(-2, 2), 0.02)
	temblor.tween_property(camara, "offset", Vector2.ZERO, 0.02)

func terminarAtaque():
	EstaAtacanddo = false
	sarten.visible = false
	hitbox.monitoring = false

func _on_hitbox_body_entered(body: Node) -> void:
	if body.has_method("recibir_golpe"):
		body.recibir_golpe(25)

func morir():
	get_tree().quit()
