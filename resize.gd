extends Node2D

func _ready() -> void:
	var screen_size := get_viewport().get_visible_rect().size
	var design_size := Vector2(1152, 648)

	position = (screen_size - design_size) / 2.0
