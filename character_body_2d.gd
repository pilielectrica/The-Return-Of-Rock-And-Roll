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

			
			weapon.z_index = 0
		else:
			# Movimiento vertical
			if (direction.y > 0 and get_global_mouse_position().y > position.y or (get_global_mouse_position().y > position.y and direction.y < 0)):
				sprite.play("walk down")
				weapon.z_index = 0
				if angle >= 57.5 and angle < 102.5:
					weapon.play("down")


			elif(direction.y < 0 and get_global_mouse_position().y < position.y or (get_global_mouse_position().y < position.y and direction.y > 0)):
				sprite.play("walk up")
				weapon.z_index = -1

	else:
		var dx = cursor.position.x - sprite.position.x
		var dy = cursor.position.y - sprite.position.y
		velocity = Vector2.ZERO
		if abs(dx) > abs(dy):
			if dx > 0:
				sprite.play("idle right")
				weapon.z_index = 0
				weapon.play("default")

			else:
				sprite.play("idle left")
				weapon.z_index = 0
				weapon.play("default")

		elif abs(dy) >= abs(dx):
			if dy > 0:
				sprite.play("idle down")
				weapon.play("front")
				weapon.z_index = 0

				if angle >= 57.5 and angle < 102.5:
					weapon.play("down")

			else:
				sprite.play("idle up")
				weapon.z_index = -1


	move_and_slide()
	var mouse_pos = get_global_mouse_position()
	var aim_dir = mouse_pos - global_position


	weapon.rotation = aim_dir.angle()
	if get_global_mouse_position().x < global_position.x:
		weapon.flip_v = true
	else:
		weapon.flip_v = false
		# cambiamos el flip del personaje seegun para donde esta apuntando el arma
	if (get_global_mouse_position().x < position.x and direction.x > 0):
		sprite.flip_h = false
	elif (get_global_mouse_position().x > position.x and direction.x < 0):
		sprite.flip_h = true
	
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	weapon.play("default")
