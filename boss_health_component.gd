extends Node2D
@export var life = 100
@export var damage = 5
signal life_70
signal life_50
signal life_25
func get_hurt():
	life -= damage
func get_life():
	return life
func reset_life():
	life = 100
func _dog_power():
		life_70.emit()
func _process(delta: float) -> void:
	if life <= 70:
		_dog_power()
	if life <= 50:
		_dog_power_2()
		print ("segundo poder perro")
	if life <= 25:
		_dog_power_3()
func _dog_power_2():
		life_50.emit()
func _dog_power_3():
		life_25.emit()
