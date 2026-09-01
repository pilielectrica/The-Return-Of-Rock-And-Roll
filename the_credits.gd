extends Node2D

@export var rythm_manager : Node2D

func _ready() -> void:
	rythm_manager.song_over.connect(show_credits)
func show_credits():
	await get_tree().create_timer(2.0).timeout
	visible = true
