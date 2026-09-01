extends Node2D

@onready var music = $FmodEventEmitter2D

func play_Part_B_Level_2():
	music.set_parameter("Level 2", 1)
func play_Part_C_Level_2():
	music.set_parameter("Level 2", 2)
func play_Part_D_Level_2():
	music.set_parameter("Level 2", 3)
func play_Game_Over_Level_2():
	music.set_parameter("Level 2", 9)
func play_Dash_Level_2():
	music.set_parameter("Level 2", 4)
