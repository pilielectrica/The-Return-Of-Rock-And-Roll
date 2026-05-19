extends Node2D

var texture_red
var texture_green

@onready var sprite = $Sprite2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	texture_red = preload("res://mira roja.png")
	texture_green = preload("res://mira verde.png")

	sprite.texture = texture_red

func _process(delta):

	global_position = get_global_mouse_position()

	var space_state = get_world_2d().direct_space_state

	var query = PhysicsPointQueryParameters2D.new()

	query.position = global_position
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result = space_state.intersect_point(query)

	var enemy_found = false

	for hit in result:

		var collider = hit.collider

		if collider.is_in_group("enemy"):
			enemy_found = true
			break

	if enemy_found:
		sprite.texture = texture_green
	else:
		sprite.texture = texture_red
