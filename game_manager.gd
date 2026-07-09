extends Node2D
var killed_enemies = 0
@export var building : Sprite2D
@export var shooter_mummies: Array[Area2D] 
@export var boss_bullets: Array[Area2D]
@export var dog_power: Area2D
var round_2 = false
func enemy_dies(_killed):
	killed_enemies += _killed
	print(killed_enemies)
func _ready() -> void:
	if (building != null):
		building.free_shooter_mummies.connect(activate_mummies)
		if (shooter_mummies != null):
			for m in shooter_mummies:
				m.process_mode = Node.PROCESS_MODE_DISABLED
				m.visible = false
	dog_power.power_finished.connect(_on_dog_power_finished)
	activate_mummies()
func activate_mummies():
	if (shooter_mummies != null):
		for m in shooter_mummies:
			m.process_mode = Node.PROCESS_MODE_INHERIT
			m.visible = true
func deactivate_boss_bullets():
	if (boss_bullets != null):
		for m in boss_bullets:
			if !m.active:
				m.process_mode = Node.PROCESS_MODE_DISABLED
				m.visible = false
func _on_dog_power_finished():
	round_2 = true
	for m in boss_bullets:
			m.process_mode = Node.PROCESS_MODE_INHERIT
			m.visible = true
			increase_bullets_speed()
func increase_bullets_speed():
	for m in boss_bullets:
		m.speed += 75
