extends Area2D
@export var bullet_mummy: Area2D
@export var marker: Marker2D
@onready var timer = $Timer
@onready var timer_2 = $Timer2
@export var player: CharacterBody2D
@onready var sprite = $Sprite2D

func _on_timer_timeout():

	if sprite.visible:
		sprite.visible = false
		timer.wait_time = 5
	else:
		sprite.visible = true
		bullet_mummy.shoot(marker.global_position, player)
		timer.wait_time = 5
