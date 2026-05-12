extends CharacterBody2D
@onready var weapon = $Sprite2D
@onready var sprite = $AnimatedSprite2D
const SPEED = 200.0


func _physics_process(delta: float) -> void:
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * SPEED
		
		# Animaciones según dirección
		if abs(direction.x) > abs(direction.y):
			# Movimiento horizontal
			sprite.play("run")
			sprite.flip_h = direction.x > 0
		else:
			# Movimiento vertical
			if direction.y > 0:
				sprite.play("walk down")
			else:
				sprite.play("walk up")
	else:
		velocity = Vector2.ZERO
		sprite.play("idle")

	move_and_slide()
	var mouse_pos = get_global_mouse_position()
	var aim_dir = mouse_pos - global_position

	weapon.rotation = aim_dir.angle()
	if get_global_mouse_position().x < global_position.x:
		weapon.flip_v = true
	else:
		weapon.flip_v = false
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
