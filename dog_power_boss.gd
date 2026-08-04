extends Area2D
@onready var collision = $CollisionShapePerro
@onready var anim = $Perro
@export var start_pos :Vector2
var target_position
@export var target : Marker2D
@export var start_marker : Marker2D
var direction  := Vector2.ZERO
var active := false
@export var speed := 300
@export var damage := 30
@export var life := 100
@export var zigzag_strength := 90
@export var zigzag_frequency := 0.03
var total_distance := 0.0
var time_alive := 0.0
var perpendicular: Vector2
var distance_traveled := 0.0
signal power_finished

func _ready() -> void:
	set_deferred("monitoring", false)
	visible = false
func dog_power() -> void:
	start_pos = start_marker.global_position
	global_position = start_pos
	distance_traveled = 0.0

	anim.visible = true
	visible = true
	active = true

	collision.set_deferred("disabled", false)
	set_deferred("monitoring", true)
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if not active:
		return

	if not is_instance_valid(target):
		disable_bullet()
		return

	direction = (target.global_position - start_pos).normalized()
	perpendicular = Vector2(-direction.y, direction.x)

	distance_traveled += speed * delta

	var forward_movement := direction * speed * delta
	var side_movement := perpendicular * sin(
		distance_traveled * zigzag_frequency
	) * zigzag_strength * delta

	global_position += forward_movement + side_movement

func disable_bullet():
	
	active = false
	visible = false
	anim.visible = false
	collision.disabled = true
	set_physics_process(false)

func _on_body_entered(body):
	if not active:
		return
	if body.is_in_group("player"):
		print("player tocado")
		anim.play("move")
		active = false
		collision.disabled = true
		if body.has_method("take_damage"):
			body.take_damage(damage)
			power_finished.emit()
			await get_tree().create_timer(2.0).timeout
			disable_bullet()
func take_damage():
	life -= 20
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		take_damage()
		if life <= 0:
			disable_bullet()
			anim.stop()
			power_finished.emit()
