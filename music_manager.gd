extends Node2D

@onready var music = $FmodEventEmitter2D

func play_Part_B_Level_1():
	music.set_parameter("Game Part", 1)
func play_Part_C_Level_1():
	music.set_parameter("Game Part", 2)
func play_Part_D_Level_1():
	music.set_parameter("Game Part", 3)
func play_Game_Over_Level_1():
	music.set_parameter("Game Part", 4)
