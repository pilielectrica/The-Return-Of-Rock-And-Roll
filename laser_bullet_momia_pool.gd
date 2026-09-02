extends Area2D

@onready var collision = $CollisionShape2D
@onready var anim = $AnimatedSprite2D
@onready var sprite_bala = $Sprite2D3
@export var speed := 250.0
@export var damage := 20
@export var explosion_distance := 8.0

var active := false
var exploding := false
var target_position := Vector2.ZERO
var direction := Vector2.ZERO

func _ready():
	body_entered.connect(_on_body_entered)
	anim.animation_finished.connect(_on_animation_finished)
	disable_bullet()

func shoot(start_pos: Vector2, player: Node2D):
	global_position = start_pos
	target_position = player.global_position
	direction = (target_position - global_position).normalized()

	visible = true
	sprite_bala.visible = true
	anim.visible = false

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
	anim.visible = true
	exploding = true
	collision.disabled = true
	anim.play("default")
	sprite_bala.visible = false
	$FmodEventEmitter2D.play()
func disable_bullet():
	active = false
	exploding = false
	visible = false
	sprite_bala.visible = false
	anim.visible = false
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
	if anim.animation == "default":
		disable_bullet()
