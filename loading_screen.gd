extends Control

var scene_path := ""
var progress := []
var dots := 0
func _ready():
	scene_path = Global.next_scene
	var screen_size := get_viewport().get_visible_rect().size
	var design_size := Vector2(1152, 648)

	position = (screen_size - design_size) / 2.0
	if scene_path == "":
		push_error("No hay escena asignada para cargar")
		return

	ResourceLoader.load_threaded_request(scene_path)


func _process(_delta):
	if scene_path == "":
		return

	var status = ResourceLoader.load_threaded_get_status(scene_path, progress)

	if progress.size() > 0:
		$ProgressBar.value = progress[0] * 100.0

	if status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(scene_path)
		get_tree().change_scene_to_packed(new_scene)

	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		push_error("Error cargando escena: " + scene_path)


func _on_timer_timeout() -> void:
	dots += 1

	if dots > 3:
		dots = 0

	$Label.text = "Loading" + ".".repeat(dots)
