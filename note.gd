extends Sprite2D
class_name RhythmNote

enum Direction {
	LEFT,
	DOWN,
	UP,
	RIGHT
}

@onready var texture_left = $FlechaIzquierda
@onready var texture_down = $FlechaAbajo
@onready var texture_up = $FlechaArriba
@onready var texture_right = $FlechaDerecha

var direction: Direction

var hit_time: float = 0.0

var spawn_y: float = -100.0
var target_y: float = 550.0
var travel_time: float = 2.0

var lane_positions := {
	Direction.LEFT: 100.0,
	Direction.DOWN: 400.0,
	Direction.UP: 700.0,
	Direction.RIGHT: 1000.0
}


func setup(
	new_direction: Direction,
	new_hit_time: float,
	new_spawn_y: float,
	new_target_y: float,
	new_travel_time: float
) -> void:

	direction = new_direction
	hit_time = new_hit_time
	spawn_y = new_spawn_y
	target_y = new_target_y
	travel_time = new_travel_time

	position.x = lane_positions[direction]
	position.y = spawn_y

	match direction:
		Direction.LEFT:
			texture = texture_left.texture

		Direction.DOWN:
			texture = texture_down.texture

		Direction.UP:
			texture = texture_up.texture

		Direction.RIGHT:
			texture = texture_right.texture

	print(
		"Direction: ",
		direction,
		" | X: ",
		lane_positions[direction]
	)


func update_note(song_time: float) -> void:
	var spawn_time := hit_time - travel_time

	var progress := inverse_lerp(
		spawn_time,
		hit_time,
		song_time
	)

	position.y = lerp(
		spawn_y,
		target_y,
		progress
	)
