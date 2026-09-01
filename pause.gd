extends CanvasLayer
@export var music : FmodEventEmitter2D

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause():
	var pause := !get_tree().paused
	get_tree().paused = pause
	$Panel.visible = pause
	var scene_name := get_tree().current_scene.name

	if scene_name in ["level_1", "level 2"]:
		FmodServer.set_global_parameter_by_name("Paused", 1 if pause else 0)
	else:
		music.paused = pause
