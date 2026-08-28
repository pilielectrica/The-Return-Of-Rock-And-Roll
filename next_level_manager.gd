extends Node2D

@export var boss : CharacterBody2D

func _ready() -> void:
	boss.no_life.connect(go_level_3)
func go_level_3():
	Global.next_scene = "res://RythmLevel.tscn"
	get_tree().change_scene_to_file("res://loadingscreen_level_3.tscn")
