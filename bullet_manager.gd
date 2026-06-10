extends Node2D

@export var bullet_scene: PackedScene
@export var player: CharacterBody2D
@export var cursor: Node2D

var muzzle
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
	if event.is_action_pressed("shoot"):
		var bullet = get_bullet()

		if bullet:
			muzzle = player.get_child(4).get_child(0)
			bullet.shoot(muzzle.global_position, cursor.global_position)
