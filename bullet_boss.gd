extends Area2D

@onready var collision = $CollisionShape2D
@onready var anim_bala = $AnimatedSprite2D
@export var speed := 250.0
@export var damage := 20
@export var explosion_distance := 8.0
@export var marker := Marker2D
@export var collider : Area2D
@export var marker_start : Marker2D
@export var player : CharacterBody2D
@onready var timer = $Timer
@export var wait_time := 5

var active := false
var exploding := false
var direction := Vector2.ZERO
var target_position
func _ready():
	timer.wait_time = wait_time
	body_entered.connect(_on_body_entered)
	collider.body_exited.connect(_on_collider_entrada_body_exit)
	timer.timeout.connect(_on_timer_timeout)
	disable_bullet()
	anim_bala.animation_finished.connect(_on_animation_finished)

func shoot(start_pos: Vector2):
	global_position = start_pos
	target_position = player.global_position
	direction = (target_position - global_position).normalized()

	visible = true
	anim_bala.play("move")
	anim_bala.visible = true

	active = true
	exploding = false
	collision.disabled = false
	set_physics_process(true)


func _physics_process(delta):
	if not active or exploding:
		return
	global_position += direction * speed * delta
	rotation += 10 * delta
	if global_position.distance_to(target_position) <= explosion_distance:
		explode()
	print(timer.time_left)

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
	set_physics_process(false)

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
func _on_collider_entrada_body_exit(body):
	if body.is_in_group("player"):
		timer.start()
		print("colisionnnn")

func _on_timer_timeout():
	shoot(marker_start.global_position)
	print("dispara")
