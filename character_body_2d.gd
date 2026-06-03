extends CharacterBody2D
@onready var weapon = $bazooka
@onready var sprite = $AnimatedSprite2D
const SPEED = 200.0
var weapon_flip = false
@export var cursor: Node2D
var dir 
var angle


func _physics_process(delta: float) -> void:
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	dir = cursor.position - sprite.position
	angle = rad_to_deg(dir.angle())
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * SPEED
		
		# Animaciones según dirección
		if abs(direction.x) > abs(direction.y):
			# Movimiento horizontal
			sprite.play("run")
			sprite.flip_h = direction.x > 0
			weapon.position.y = -2

			
			weapon.z_index = 0
		else:
			# Movimiento vertical
			if (direction.y > 0 and get_global_mouse_position().y > position.y or (get_global_mouse_position().y > position.y and direction.y < 0)):
				sprite.play("walk down")
				weapon.z_index = 0
				weapon.position.y = 0



			elif(direction.y < 0 and get_global_mouse_position().y < position.y or (get_global_mouse_position().y < position.y and direction.y > 0)):
				sprite.play("walk up")
				weapon.z_index = -1
				weapon.position.y = -22

	else:
		var dx = get_global_mouse_position().x - sprite.global_position.x
		var dy = get_global_mouse_position().y - sprite.global_position.y
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


		elif abs(dy) >= abs(dx):
			if dy > 0:
				sprite.play("idle down")
				weapon.z_index = 0

			else:
				sprite.play("idle up")
				weapon.z_index = -1
				weapon.position.y = -22


	move_and_slide()
	var mouse_pos = get_global_mouse_position()
	var aim_dir = mouse_pos - global_position


	weapon.rotation = aim_dir.angle()
	if get_global_mouse_position().x < global_position.x:
		weapon.flip_v = true
		weapon.position.x = -4
	else:
		weapon.flip_v = false
		weapon.position.x = 8

		# cambiamos el flip del personaje seegun para donde esta apuntando el arma
	if (get_global_mouse_position().x < position.x and direction.x > 0):
		sprite.flip_h = false

	elif (get_global_mouse_position().x > position.x and direction.x < 0):
		sprite.flip_h = true
	elif (sprite.animation == "idle right") or (sprite.animation == "idle left"):
		sprite.flip_h = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	weapon.play("default")
