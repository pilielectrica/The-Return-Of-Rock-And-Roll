extends Button
@export var play_exit_buttons : Node2D

func _on_pressed() -> void:
	play_exit_buttons.visible = true
	get_parent().visible = false
