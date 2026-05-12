extends Area2D
var velocity = Vector2.ZERO
var SPEED = 200
var direction
var distance
var click_pos
@export var start_pos: CharacterBody2D
@onready var sprite_fire = $Fire
@onready var sprite_explosion = $Explosion

func _ready() -> void:
	sprite_explosion.visible = false
func _shoot():
	position = start_pos.position
	direction = (click_pos - global_position).normalized()
	distance = global_position.distance_to(click_pos)
	velocity = direction *  SPEED
	sprite_fire.play("default")
	if (distance <= 1):
		sprite_explosion.visible = true
		sprite_explosion.play("default")
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			click_pos = get_global_mouse_position()
			_shoot()
func _physics_process(delta):
	position += velocity * get_process_delta_time()
