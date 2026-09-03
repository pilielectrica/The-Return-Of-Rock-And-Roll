extends CanvasLayer

@onready var play_again_button = $Node2D/Play_Again_Button

func _on_play_again_button_pressed() -> void:
		Global.next_scene = "res://level 2.tscn"
		get_tree().change_scene_to_file("res://loadingscreen_level_2.tscn")
