extends Button
@export var play_exit_buttons : Node2D
@export var play_button : TextureButton
func _on_pressed() -> void:
	get_parent().visible = false
	if (play_button != null and play_exit_buttons != null):
		play_exit_buttons.visible = true
		play_button.grab_focus()
	get_tree().paused = false
