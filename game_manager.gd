extends Node2D
var killed_enemies = 0
@export var building : Sprite2D
@export var shooter_mummies: Array[Area2D] 
@export var boss_bullets: Array[Area2D]
@export var dog_power: Area2D
@export var speed_increase_bullets := 25
@export var speed_increase_dog_power := 50
@export var zigzag_increase_dog_power := 50
@export var last_jero_level_1 : Area2D
var killed_shooters = 0
var round_2 = false
func enemy_dies(_killed):
	killed_enemies += _killed
	print(killed_enemies)
func _ready() -> void:
	if (building != null):
		building.free_shooter_mummy.connect(activate_mummies)
		if (shooter_mummies != null):
			for m in shooter_mummies:
				m.process_mode = Node.PROCESS_MODE_DISABLED
				m.visible = false
	if dog_power != null:
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

func increase_bullets_speed():
	for m in boss_bullets:
		m.speed += speed_increase_bullets
func increase_dog_power_speed():
	dog_power.speed += speed_increase_dog_power
	dog_power.zigzag_strength += zigzag_increase_dog_power
func check_last_jero_level_1():
	for m in shooter_mummies:
		if m.killed:
			killed_shooters +1
			if killed_shooters == 4:
				last_jero_level_1.set_jero_visible()
