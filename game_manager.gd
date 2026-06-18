extends Node2D
var killed_enemies = 0
@export var building = Sprite2D
@export var shooter_mummies: Array[Area2D] 
func enemy_dies(_killed):
	killed_enemies += _killed
	print(killed_enemies)
func _ready() -> void:
	building.free_shooter_mummies.connect(activate_mummies)
	for m in shooter_mummies:
		m.process_mode = Node.PROCESS_MODE_DISABLED
		m.visible = false
	activate_mummies()
func activate_mummies():
	for m in shooter_mummies:
		m.process_mode = Node.PROCESS_MODE_INHERIT
		m.visible = true
