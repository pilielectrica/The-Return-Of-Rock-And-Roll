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
@export var guitar : StaticBody2D
@export var boss: AnimatedSprite2D
var killed_shooters = 0
var round_2 = false
var done = false
@export var green_effect : AnimatedSprite2D
@export var player : CharacterBody2D
@export var game_over_screen : CanvasLayer
func enemy_dies(_killed):
	killed_enemies += _killed
	print(killed_enemies)
func _ready() -> void:
	player.game_over.connect(_game_over_screen)
	if (building != null):
		building.free_shooter_mummy.connect(activate_mummies)
		if (shooter_mummies != null):
			for m in shooter_mummies:
				m.process_mode = Node.PROCESS_MODE_DISABLED
				m.visible = false
				m.die.connect(check_last_jero_level_1)
	if (guitar != null):
		guitar.guitar_free_signal.connect(level_2_screen)
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
	killed_shooters += 1
	if killed_shooters == 4:
		last_jero_level_1.set_jero_visible()
		return
func level_2_screen():
	boss.visible = true
	boss.play("attack_2")
	await get_tree().create_timer(2.0).timeout
	guitar.visible = false
	guitar.process_mode = Node.PROCESS_MODE_DISABLED
	green_effect.process_mode = Node.PROCESS_MODE_DISABLED
	green_effect.visible = false
	await get_tree().create_timer(2.0).timeout
	go_to_level_2()
func go_to_level_2():
	Global.next_scene = "res://level 2.tscn"
	get_tree().change_scene_to_file("res://loadingscreen.tscn")
func _game_over_screen():
	game_over_screen.visible = true
	print ("entro en la funcion game over screen")
