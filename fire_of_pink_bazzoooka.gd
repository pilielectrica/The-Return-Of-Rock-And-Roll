extends Area2D

var velocity = Vector2.ZERO
var SPEED = 500
var active = false

@onready var sprite_fire = $Fire
@onready var collision = $CollisionShape2D
@export var shoot_sound : FmodEventEmitter2D
func _ready():
	visible = false


func shoot(start_position: Vector2, target_position: Vector2):
	global_position = start_position
	shoot_sound.play()
	var direction = (target_position - global_position).normalized()
	velocity = direction * SPEED
	
	active = true
	visible = true
	set_deferred("monitoring", true)
	collision.set_deferred("disabled", false)
	

	sprite_fire.visible = true
	sprite_fire.play("default")
	await get_tree().create_timer(2.0).timeout
	deactivate()

func _physics_process(delta):
	if !active:
		return
	
	position += velocity * delta

func deactivate():
	active = false
	visible = false
	velocity = Vector2.ZERO
	set_deferred("monitoring", false)
	collision.set_deferred("disabled", true)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		deactivate()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("house"):
		deactivate()
