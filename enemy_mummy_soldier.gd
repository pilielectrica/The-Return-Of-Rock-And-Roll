extends CharacterBody2D
@export var player: Node2D
@export var SPEED: float = 160
var direction
var distance
var moving = true

@onready var anim = $AnimatedSprite2D

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
		if (abs(pos_dif.x) > abs(pos_dif.y)):
			if ((direction.x > 0)):
				anim.play(" walk left or right")
				anim.flip_h = false
			elif (direction.x < 0):
				anim.play(" walk left or right")
				anim.flip_h = true
		elif (abs(pos_dif.y) > abs(pos_dif.x)):
			if (direction.y < 0):
				anim.play("walk up")
			elif (direction.y > 0):
				anim.play("walk down")
