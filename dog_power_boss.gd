extends Area2D
@onready var collision = $CollisionShapePerro
@onready var anim = $Perro
@export var start_pos = 0
var target_position
@export var target : Marker2D
var direction  := Vector2.ZERO
var active := false
@export var speed := 250
@export var damage := 30
@export var life := 100
@export var zigzag_strength := 120
@export var zigzag_frequency := 0.05
var total_distance := 0.0
var time_alive := 0.0
var perpendicular: Vector2
var distance_traveled := 0.0

signal power_finished
func _ready() -> void:
	set_deferred("monitoring", false)
	visible = false
	anim.animation_finished.connect(_on_animation_finished)
func dog_power():
	set_physics_process(true)
	set_deferred("monitoring", true)

	start_pos = global_position
	target_position = target.global_position

	direction = (target_position - start_pos).normalized()
	perpendicular = Vector2(-direction.y, direction.x)

	distance_traveled = 0.0
	total_distance = start_pos.distance_to(target_position)

	anim.visible = true
	active = true
	collision.disabled = false


func _physics_process(delta):
	if not active:
		return

	distance_traveled += speed * delta

	var base_position = start_pos + direction * distance_traveled
	var side_offset = perpendicular * sin(distance_traveled * zigzag_frequency) * zigzag_strength

	global_position = base_position + side_offset

	if distance_traveled >= total_distance:
		active = false
		visible = false
		set_deferred("monitoring", false)

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
		anim.play("hit")
		if body.has_method("take_damage"):
			body.take_damage(damage)
func _on_animation_finished():
	if anim.animation == "hit":
		disable_bullet()
		print ("animacion hit terminada")
		power_finished.emit()
func take_damage():
	life -= 20
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		take_damage()
		if life <= 0:
			disable_bullet()
			power_finished.emit()
