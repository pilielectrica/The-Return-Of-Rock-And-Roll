extends Node2D
@export var life = 100
@export var damage = 10

func get_hurt():
	life -= damage
func get_life():
	return life
func reset_life():
	life = 100
