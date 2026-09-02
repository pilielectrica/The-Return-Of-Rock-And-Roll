extends TextureButton



func _on_pressed() -> void:
	Global.next_scene = "res://level_1.tscn"
	get_tree().change_scene_to_file("res://loadingscreen.tscn")
