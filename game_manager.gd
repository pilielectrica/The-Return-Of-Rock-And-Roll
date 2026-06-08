extends Node2D
var killed_enemies = 0

func enemy_dies(_killed):
	killed_enemies += _killed
	print(killed_enemies)
