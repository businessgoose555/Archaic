extends CharacterBody2D

@export var radius: float = 50.0
@export var angular_speed: float = 2.0

var angle: float = 0.0
var player: CharacterBody2D

func fireball():
	pass

func _ready() -> void:
	player = get_node("player")
	$AnimatedSprite2D.play("fireball_anim")

func _physics_process(delta: float) -> void:
	angle += angular_speed * delta
	var offset = Vector2(radius, 0).rotated(angle)
	position = offset
	move_and_slide()
