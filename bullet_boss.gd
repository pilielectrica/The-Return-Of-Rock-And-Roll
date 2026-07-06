extends Area2D

@onready var collision = $CollisionShape2D
@onready var anim_bala = $AnimatedSprite2D
@export var speed := 250.0
@export var damage := 20
@export var explosion_distance := 8.0
@export var marker := Marker2D

var active := false
var exploding := false
var direction := Vector2.ZERO
var target_position
func _ready():
	body_entered.connect(_on_body_entered)
	disable_bullet()

func shoot(start_pos: Vector2, player: Node2D):
	global_position = start_pos
	target_position = marker
	direction = (target_position - global_position).normalized()

	visible = true
	anim_bala.visible = true

	active = true
	exploding = false
	collision.disabled = false
	process_mode = Node.PROCESS_MODE_INHERIT


func _physics_process(delta):
	if not active or exploding:
		return
	global_position += direction * speed * delta
	rotation += 10 * delta

	if global_position.distance_to(target_position) <= explosion_distance:
		explode()

func explode():
	anim_bala.visible = true
	exploding = true
	collision.disabled = true
	anim_bala.play("hit")

func disable_bullet():
	active = false
	exploding = false
	visible = false
	anim_bala.visible = false
	collision.disabled = true
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_body_entered(body):
	if not active or exploding:
		return

	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)

		explode()

func _on_animation_finished():
	if anim_bala.animation == "hit":
		disable_bullet()
