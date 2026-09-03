extends TextureButton

@export var level_buttons : Node2D
@export var level_1_button : TextureButton
func _ready() -> void:
	grab_focus()
func _on_pressed() -> void:
	level_buttons.visible = true
	get_parent().visible = false
	level_1_button.grab_focus()
