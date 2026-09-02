extends TextureButton

func _ready() -> void:
	if SaveManager.load_level_2_complete() == true:
		disabled = false
	else:
		disabled = true
func _on_pressed() -> void:
	Global.next_scene = "res://RythmLevel.tscn"
	get_tree().change_scene_to_file("res://loadingscreen_level_3.tscn")
