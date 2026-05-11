extends Node2D

@export var enemigo_scene: PackedScene
@export var spawn_points: Array[Node2D]
@export var tiempo_spawn: float = 2.0
@export var player: Node2D

func _ready():
	var timer = Timer.new()
	timer.wait_time = tiempo_spawn
	timer.autostart = true
	timer.timeout.connect(spawn_enemigo)
	add_child(timer)

func spawn_enemigo():
	if spawn_points.is_empty():
		return
	
	var enemigo = enemigo_scene.instantiate()
	var punto = spawn_points.pick_random()
	
	enemigo.global_position = punto.global_position
	enemigo.player = player
	
	add_child(enemigo)
