extends Node2D

@onready var timer = $Timer
@export var marker: Marker2D
@export var enemy: Array[CharacterBody2D]
@export var spawn_wait_time := 5.0
@export var building: Sprite2D

func _ready():
	dummy_spawn()
	timer.wait_time = spawn_wait_time
	building.building_hit.connect(_on_building_hit)
	building.building_destroyed.connect(_on_building_destroyed)

	for e in enemy:
		disable_enemy(e)

	if !building.house_2:
		if timer.is_stopped():
			timer.start()
func _on_building_hit():
	if (building.house_2):
		if timer.is_stopped():
			spawn_enemy()
			timer.start()
	else:
		spawn_enemy()
func _on_timer_timeout() -> void:
	spawn_enemy()
func spawn_enemy():
	var e = get_inactive_enemy()
	if e == null:
		return
	e.global_position = marker.global_position
	e.visible = true
	e.process_mode = Node.PROCESS_MODE_INHERIT
	#e.get_node("CollisionShape2D").disabled = false
	if e.has_method("reset_enemy"):
		e.reset_enemy()
func get_inactive_enemy():
	for e in enemy:
		if e.process_mode == Node.PROCESS_MODE_DISABLED:
			return e
	return null
func disable_enemy(e):
	e.process_mode = Node.PROCESS_MODE_DISABLED
	e.visible = false
	#e.get_node("CollisionShape2D").disabled = true
func _on_building_destroyed():
	timer.stop()
func dummy_spawn():
	await get_tree().create_timer(5.0).timeout
	spawn_enemy()
