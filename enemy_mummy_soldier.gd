extends CharacterBody2D
@export var player: Node2D
@export var SPEED: float = 160
var direction
var distance
var moving = true
var atack = false
@onready var anim = $AnimatedSprite2D
@onready var momia_power = $AnimatedSprite2D/Area2D/AnimatedSprite2D
@onready var momia_eyes = $AnimatedSprite2D2
@onready var momia_eye = $AnimatedSprite2D3
var momia_eye_left =  false
var momia_eye_right = false
var momia_eye_down = false
func _physics_process(delta):
	var pos_dif = player.position - position
	if (moving):
		direction = (player.position - position).normalized()
		distance = position.distance_to(player.position)
		velocity = direction * SPEED
		move_and_slide()
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
func _atack():
	if (atack ==true):
		momia_power.visible = true
		momia_power.play("poder_momia")
		anim.pause()
		if (momia_eye_down):
			momia_eyes.visible = true
			momia_eyes.play("default")
			momia_eye.visible = false
			if (anim.frame == 1):
				momia_eyes.position.y = -4.33
			else:
				momia_eyes.position.y = -2.96
		if (momia_eye_left):
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
		else:
			momia_eye.visible = false
			momia_eye.visible = false

		moving = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		atack = true
		_atack()
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		atack = false
		momia_power.visible = false
		moving = true
		momia_eyes.visible = false
		momia_eye.visible = false
