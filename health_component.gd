extends Node2D
@export var life = 100


func get_hurt():
	life -= 20
func get_life():
	return life
func reset_life():
	life = 100
