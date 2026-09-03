extends Node2D

@export var rythm_manager : Node2D
@onready var play_button = $Play_Again_Button
func _ready() -> void:
	rythm_manager.song_over.connect(show_credits)
	play_button.grab_focus()
func show_credits():
	await get_tree().create_timer(2.0).timeout
	visible = true
