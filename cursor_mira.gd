extends Node2D

var texture_red
var texture_green

@onready var sprite = $Sprite2D

@export var player: Node2D
@export var cursor_speed := 600.0
@export var max_distance_from_player := 300.0

var using_joystick := false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	texture_red = preload("res://mira roja.png")
	texture_green = preload("res://mira verde.png")

	sprite.texture = texture_red

func _process(delta):
	var aim = Input.get_vector(
		"aim_left",
		"aim_right",
		"aim_up",
		"aim_down"
	)

	if aim.length() > 0.1:
		using_joystick = true
		global_position += aim * cursor_speed * delta

		var offset = global_position - player.global_position

		if offset.length() > max_distance_from_player:
			global_position = player.global_position + offset.normalized() * max_distance_from_player
	else:
		if not using_joystick:
			global_position = get_global_mouse_position()

	check_target()

func _input(event):
	if event is InputEventMouseMotion:
		using_joystick = false

func check_target():
	var space_state = get_world_2d().direct_space_state

	var query = PhysicsPointQueryParameters2D.new()
	query.position = global_position
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var result = space_state.intersect_point(query)

	var enemy_found = false

	for hit in result:
		var collider = hit.collider

		if collider.is_in_group("enemy") or collider.is_in_group("house"):
			enemy_found = true
			break

	sprite.texture = texture_green if enemy_found else texture_red
