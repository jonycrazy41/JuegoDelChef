extends RigidBody2D

signal horno_encendido

@onready var interactuable: Area2D = $Interactuable
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var habilitado: bool = false
var ya_encendido: bool = false
var jugador_cerca: bool = false
var animacion: Tween
var poscicionbase: Vector2
var nivel: Node2D

func _ready() -> void:
	sprite.play("apagadooo")
	poscicionbase = sprite.position

	interactuable.body_entered.connect(_cuando_jugador_entra)
	interactuable.body_exited.connect(_cuando_jugador_sale)

	nivel = get_tree().current_scene
	if nivel and nivel.has_signal("todas_muertas"):
		nivel.todas_muertas.connect(habilitar)

func habilitar() -> void:
	if habilitado:
		return
	habilitado = true
	print("Horno desbloqueado")

func _unhandled_input(event: InputEvent) -> void:
	if not habilitado or ya_encendido:
		return
	if jugador_cerca and event.is_action_pressed("interactuar"):
		encender()

func _cuando_jugador_entra(body: Node) -> void:
	if body.is_in_group("player"):
		jugador_cerca = true

func _cuando_jugador_sale(body: Node) -> void:
	if body.is_in_group("player"):
		jugador_cerca = false

func encender() -> void:
	if ya_encendido:
		return
	ya_encendido = true
	sprite.play("prendidooo")
	_iniciar_wiggle()
	horno_encendido.emit()

func _iniciar_wiggle() -> void:
	if animacion and animacion.is_valid():
		animacion.kill()
	animacion = create_tween().set_loops()
	animacion.tween_property(sprite, "position",
			poscicionbase + Vector2(1, -1), 0.05)
	animacion.tween_property(sprite, "position",
			poscicionbase + Vector2(-1, 1), 0.05)
	animacion.tween_property(sprite, "position",
			poscicionbase, 0.05)
