extends Control

var scene_path := ""
var progress := []
var dots := 0

var loaded_scene: PackedScene
var load_finished := false
var minimum_time_finished := false


func _ready():
	scene_path = Global.next_scene
	var screen_size := get_viewport().get_visible_rect().size
	var design_size := Vector2(1152, 648)

	position = (screen_size - design_size) / 2.0
	if scene_path == "":
		push_error("No hay escena asignada para cargar")
		return

	ResourceLoader.load_threaded_request(scene_path)

	# La loading screen se queda al menos 5 segundos.
	wait_minimum_time()


func wait_minimum_time() -> void:
	await get_tree().create_timer(5.0).timeout

	minimum_time_finished = true

	try_change_scene()


func _process(_delta):
	if scene_path == "":
		return

	if load_finished:
		return

	var status = ResourceLoader.load_threaded_get_status(
		scene_path,
		progress
	)

	if progress.size() > 0:
		$ProgressBar.value = progress[0] * 100.0

	if status == ResourceLoader.THREAD_LOAD_LOADED:

		loaded_scene = ResourceLoader.load_threaded_get(
			scene_path
		)

		load_finished = true

		$ProgressBar.value = 100.0

		try_change_scene()

	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		push_error(
			"Error cargando escena: " + scene_path
		)


func try_change_scene() -> void:

	if load_finished and minimum_time_finished:

		get_tree().change_scene_to_packed(
			loaded_scene
		)


func _on_timer_timeout() -> void:
	dots += 1

	if dots > 3:
		dots = 0

	$Label.text = "Loading" + ".".repeat(dots)
