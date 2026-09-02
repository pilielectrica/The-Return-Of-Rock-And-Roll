extends TextureButton

func _ready() -> void:
	if SaveManager.load_level_1_complete() == true:
		disabled = false
	else:
		disabled = true
func _on_pressed() -> void:
	Global.next_scene = "res://level 2.tscn"
	get_tree().change_scene_to_file("res://loadingscreen_level_2.tscn")
