extends CharacterBody2D
@export var player: Node2D
@export var SPEED: float = 160
var direction
var distance
var moving = true
var atack = false
@onready var anim = $AnimatedSprite2D
@onready var momia_power = $AnimatedSprite2D/AnimatedSprite2D
@onready var momia_eyes = $AnimatedSprite2D2
@onready var momia_eye = $AnimatedSprite2D3
@onready var health = $"Health Component"
@onready var health_bar = $"Health Component/CanvasGroup/ProgressBar"
@onready var collision_body = $CollisionShape2D
var momia_eye_left =  false
var momia_eye_right = false
var momia_eye_down = false
var life = 100
@export var explosion_scene: PackedScene
@export var game_manager: Node2D
var dead_count = false
var change_dir := false
var avoid_direction := Vector2.ZERO
var avoid_time := 0.0
var damage = false
var dead = false
func _physics_process(delta):
	var pos_dif = player.global_position - global_position
	if (moving):
		if change_dir:
			avoid_time -= delta
			direction = avoid_direction

			if avoid_time <= 0:
				change_dir = false
		else:
			direction = (player.global_position - global_position).normalized()

		velocity = direction * SPEED
		move_and_slide()
		distance = position.distance_to(player.position)

		if (distance < 5):
			moving = false
			velocity = Vector2.ZERO
		if (abs(pos_dif.x) > abs(pos_dif.y)) and (atack == false):
			if ((direction.x > 0)):
				anim.play(" walk left or right")
				anim.flip_h = false
				momia_power.rotation = -180
				momia_eye_right = true
				momia_eye_left = false
				momia_eye_down = false
			elif (direction.x < 0)and atack==false:
				anim.play(" walk left or right")
				anim.flip_h = true
				momia_eye_left = true
				momia_eye_right = false
				momia_eye_down = false
				momia_power.rotation = 0
		elif (abs(pos_dif.y) > abs(pos_dif.x)) and atack == false:
			if (direction.y < 0):
				anim.play("walk up")
				momia_power.rotation = 90
				momia_eye_down = false
				momia_eye_left = false
				momia_eye_right = false
			elif (direction.y > 0):
				anim.play("walk down")
				momia_power.rotation = -90
				momia_eye_down = true
				momia_eye_right = false
				momia_eye_right = false
	if (health.get_life() <= 0):
		
		die()

	
func _atack():
	if (atack ==true):
		momia_power.visible = true
		momia_power.play("poder_momia")
		$FmodEventEmitter2D.play()
		anim.pause()
		if (momia_eye_down):
			momia_eyes.visible = true
			momia_eyes.play("default")
			momia_eye.visible = false
			if (anim.frame == 1):
				momia_eyes.position.y = -4.33
			else:
				momia_eyes.position.y = -2.96
		elif (momia_eye_left):
			momia_eye.play("default")
			momia_eye.visible = true
			momia_eye.position.x = -9.025
			momia_eye.flip_h = true
			momia_eyes.visible = false
		elif (momia_eye_right):
			momia_eye.play("default")
			momia_eye.visible = true
			momia_eye.position.x = 7.265
			momia_eye.flip_h = false
			momia_eyes.visible = false


		moving = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		atack = true
		_atack()
		if !damage:
			if body.has_method("take_damage"):
				body.take_damage(5)
				damage = true
				print ("aplicado el daño" + "vida es: " + str(body.get_child(6).life))
		collision_body.disabled = false



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		atack = false
		momia_power.visible = false
		moving = true
		momia_eyes.visible = false
		momia_eye.visible = false
		damage = false
		#collision_body.disabled = true

func _ready():
		momia_eye.visible = false
		momia_eyes.visible = false
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		health.get_hurt()
		health_bar.value = health.get_life()

func die():
	atack = false 
	var explosion = explosion_scene.instantiate()
	if !dead:
		$FmodEventEmitter2D2.play_one_shot()
		dead = true

	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position
	anim.play("idle")
	moving = false
	collision_body.disabled = true
	if(dead_count != true):
		game_manager.enemy_dies(1)
		dead_count = true
	await get_tree().create_timer(2.0).timeout
	deactivate_enemy()
func deactivate_enemy():
	process_mode = Node.PROCESS_MODE_DISABLED
	visible = false
	collision_body.disabled = true
	dead = false
func reset_enemy():
	moving = true
	atack = false
	dead_count = false
	health.reset_life()
	health_bar.value = health.get_life()
	collision_body.disabled = false

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("arboles"):
		change_dir = true
		avoid_time = 0.6

		if randi() % 2 == 0:
			avoid_direction = Vector2.UP
		else:
			avoid_direction = Vector2.DOWN
