extends CharacterBody2D

@onready var weapon = $bazooka
@onready var sprite = $AnimatedSprite2D
@export var camera_zoom: Vector2 = Vector2(1, 1)

@onready var camera = $Camera2D
@export var speed = 200.0

@export var cursor: Node2D

var dir
var angle

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	weapon.play("default")
	camera.zoom = camera_zoom

func _physics_process(delta: float) -> void:
	var direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	var aim_pos = cursor.global_position
	var aim_dir = aim_pos - global_position

	dir = cursor.global_position - sprite.global_position
	angle = rad_to_deg(dir.angle())

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed

		if abs(direction.x) > abs(direction.y):
			sprite.play("run")
			sprite.flip_h = direction.x > 0
			weapon.position.y = -2
			weapon.z_index = 0
		else:
			if direction.y > 0 and aim_pos.y > global_position.y or aim_pos.y > global_position.y and direction.y < 0:
				sprite.play("walk down")
				weapon.z_index = 0
				weapon.position.y = 0

			elif direction.y < 0 and aim_pos.y < global_position.y or aim_pos.y < global_position.y and direction.y > 0:
				sprite.play("walk up")
				weapon.z_index = -1
				weapon.position.y = -22

	else:
		var dx = aim_pos.x - sprite.global_position.x
		var dy = aim_pos.y - sprite.global_position.y

		velocity = Vector2.ZERO

		if abs(dx) > abs(dy):
			if dx > 0:
				sprite.play("idle right")
				weapon.z_index = 0
				weapon.play("default")
				weapon.position.y = -2
			else:
				sprite.play("idle left")
				weapon.z_index = 0
				weapon.play("default")
				weapon.position.y = -2

		else:
			if dy > 0:
				sprite.play("idle down")
				weapon.z_index = 0
			else:
				sprite.play("idle up")
				weapon.z_index = -1
				weapon.position.y = -22

	move_and_slide()

	weapon.rotation = aim_dir.angle()

	if aim_pos.x < global_position.x:
		weapon.flip_v = true
		weapon.position.x = -4
	else:
		weapon.flip_v = false
		weapon.position.x = 8

	if aim_pos.x < global_position.x and direction.x > 0:
		sprite.flip_h = false
	elif aim_pos.x > global_position.x and direction.x < 0:
		sprite.flip_h = true
	elif sprite.animation == "idle right" or sprite.animation == "idle left":
		sprite.flip_h = false
