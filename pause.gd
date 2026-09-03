extends CanvasLayer
@export var music : FmodEventEmitter2D
@onready var sfx_volume = $"Panel/Sfx Volume"
@onready var music_volume = $"Panel/Music Volume"
@export var player = CharacterBody2D
var music_bus
var sfx_bus
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	music_bus = FmodServer.get_bus("bus:/Music")
	sfx_bus = FmodServer.get_bus("bus:/SFX")
	var scene_name := get_tree().current_scene.name
	if scene_name in ["level_1", "level 2"]:
		FmodServer.set_global_parameter_by_name("Paused", 0)
		music.paused = false
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause():
	var pause := !get_tree().paused

	if player != null and player.game_over_:
		return

	get_tree().paused = pause
	$Panel.visible = pause

	if pause:
		$"Panel/Back Button".grab_focus()

	var scene_name := get_tree().current_scene.name

	if scene_name in ["level_1", "level 2"]:
		FmodServer.set_global_parameter_by_name(
			"Paused",
			1 if pause else 0
		)
	else:
		music.paused = pause
func _on_music_volume_value_changed(value: float) -> void:
	var volume := value / 100.0
	music_bus.set_volume(volume)


func _on_sfx_volume_value_changed(value: float) -> void:
	var volume := value / 100.0
	sfx_bus.set_volume(volume)


func _on_back_button_pressed() -> void:
	toggle_pause()
