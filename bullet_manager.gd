extends Node2D

@export var bullet_scene: PackedScene
@export var player: CharacterBody2D

var bullet_pool = []

func _ready():
	for i in range(5):
		var bullet = bullet_scene.instantiate()
		
		add_child(bullet)
		bullet_pool.append(bullet)

func get_bullet():
	for bullet in bullet_pool:
		if !bullet.active:
			return bullet
	
	return null

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			
			var bullet = get_bullet()
			
			if bullet:
				var mouse_pos = get_global_mouse_position()
				bullet.shoot(player.global_position, mouse_pos)
