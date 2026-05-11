extends CharacterBody2D


@export var player: Node2D
@export var SPEED: float = 160
var direction
var distance
var moving = true
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	if (moving):
		direction = (player.position - position).normalized()
		distance = position.distance_to(player.position)
		velocity = direction * SPEED
		move_and_slide()
		if (distance < 5):
			moving = false
			velocity = Vector2.ZERO
