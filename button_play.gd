extends TextureButton

@export var level_buttons : Node2D

func _on_pressed() -> void:
	level_buttons.visible = true
	get_parent().visible = false
