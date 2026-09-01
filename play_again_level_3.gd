extends Button


func _on_pressed() -> void:
	Global.next_scene = "res://RythmLevel.tscn"
	get_tree().change_scene_to_file("res://loadingscreen_level_3.tscn")
