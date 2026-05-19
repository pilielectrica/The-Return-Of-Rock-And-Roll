extends Area2D

var velocity = Vector2.ZERO
var SPEED = 500
var active = false

@onready var sprite_fire = $Fire
@onready var sprite_explosion = $Explosion

func _ready():
	visible = false
	sprite_explosion.visible = false

func shoot(start_position: Vector2, target_position: Vector2):
	global_position = start_position
	
	var direction = (target_position - global_position).normalized()
	velocity = direction * SPEED
	
	active = true
	visible = true
	
	sprite_explosion.visible = false
	sprite_fire.visible = true
	sprite_fire.play("default")
	await get_tree().create_timer(1.0).timeout
	deactivate()

func _physics_process(delta):
	if !active:
		return
	
	position += velocity * delta

func deactivate():
	active = false
	visible = false
	velocity = Vector2.ZERO
