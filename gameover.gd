extends CanvasLayer

@onready var play_again_button = $Node2D2/Play_Again_Button

func _on_play_again_button_pressed() -> void:
		Global.next_scene = "res://level 2.tscn"
		get_tree().change_scene_to_file("res://loadingscreen_level_2.tscn")


func _ready() -> void:
	var screen_size := get_viewport().get_visible_rect().size
	var design_size := Vector2(1152, 648)

	$Node2D/CanvasGroup.position = (screen_size - design_size) / 2.0
	$Node2D2.position = (screen_size - design_size) / 2.0
