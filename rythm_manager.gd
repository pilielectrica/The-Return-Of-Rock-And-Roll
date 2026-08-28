extends Node

@export var note_scene: PackedScene
@export var notes_container: Node2D

@export var bpm := 110.0
@export var travel_time := 2.0
@export var spawn_y := -100.0
@export var target_y := 550.0
@export var pattern_gap_beats := 1.0

# Duración total de la canción EN SEGUNDOS.
# Cambiala por la duración real.
@export var song_duration := 120.0

@onready var music = $FmodEventEmitter2D
@onready var score_manager = $Score_Manager

var seconds_per_beat: float
var song_time := 0.0
var fmod_playing := false

var next_pattern_beat := 4.0
var pending_notes: Array = []

var second_half := false


# -------------------------
# FEEDBACK
# -------------------------

@export var perfect_sprite: Sprite2D
@export var great_sprite: Sprite2D
@export var good_sprite: Sprite2D
@export var miss_sprite: Sprite2D

@export var perfect_window := 0.05
@export var great_window := 0.10
@export var good_window := 0.16


# ============================================
# PATRONES PRIMERA MITAD
# ============================================

var patterns_first_half = [
	[
		{"offset": 0.0, "direction": RhythmNote.Direction.LEFT},
		{"offset": 1.0, "direction": RhythmNote.Direction.DOWN},
		{"offset": 2.0, "direction": RhythmNote.Direction.UP},
		{"offset": 3.0, "direction": RhythmNote.Direction.RIGHT}
	],

	[
		{"offset": 0.0, "direction": RhythmNote.Direction.LEFT},
		{"offset": 1.0, "direction": RhythmNote.Direction.UP},
		{"offset": 2.0, "direction": RhythmNote.Direction.LEFT},
		{"offset": 3.0, "direction": RhythmNote.Direction.RIGHT}
	],

	[
		{"offset": 0.0, "direction": RhythmNote.Direction.DOWN},
		{"offset": 1.0, "direction": RhythmNote.Direction.DOWN},
		{"offset": 2.0, "direction": RhythmNote.Direction.UP},
		{"offset": 3.0, "direction": RhythmNote.Direction.RIGHT}
	],

	[
		{"offset": 0.0, "direction": RhythmNote.Direction.RIGHT},
		{"offset": 1.0, "direction": RhythmNote.Direction.LEFT},
		{"offset": 2.0, "direction": RhythmNote.Direction.DOWN},
		{"offset": 3.0, "direction": RhythmNote.Direction.UP}
	]
]


# ============================================
# PATRONES SEGUNDA MITAD
# Más rápidos / más difíciles
# ============================================

var patterns_second_half = [
	# Corcheas
	[
		{"offset": 0.0, "direction": RhythmNote.Direction.LEFT},
		{"offset": 0.5, "direction": RhythmNote.Direction.DOWN},
		{"offset": 1.0, "direction": RhythmNote.Direction.UP},
		{"offset": 1.5, "direction": RhythmNote.Direction.RIGHT},
		{"offset": 2.0, "direction": RhythmNote.Direction.LEFT},
		{"offset": 2.5, "direction": RhythmNote.Direction.UP},
		{"offset": 3.0, "direction": RhythmNote.Direction.DOWN},
		{"offset": 3.5, "direction": RhythmNote.Direction.RIGHT}
	],

	# Izquierda / derecha alternado
	[
		{"offset": 0.0, "direction": RhythmNote.Direction.LEFT},
		{"offset": 0.5, "direction": RhythmNote.Direction.RIGHT},
		{"offset": 1.0, "direction": RhythmNote.Direction.LEFT},
		{"offset": 1.5, "direction": RhythmNote.Direction.RIGHT},
		{"offset": 2.0, "direction": RhythmNote.Direction.DOWN},
		{"offset": 2.5, "direction": RhythmNote.Direction.UP},
		{"offset": 3.0, "direction": RhythmNote.Direction.DOWN},
		{"offset": 3.5, "direction": RhythmNote.Direction.UP}
	],

	# Mezcla
	[
		{"offset": 0.0, "direction": RhythmNote.Direction.DOWN},
		{"offset": 1.0, "direction": RhythmNote.Direction.LEFT},
		{"offset": 1.5, "direction": RhythmNote.Direction.UP},
		{"offset": 2.0, "direction": RhythmNote.Direction.RIGHT},
		{"offset": 2.5, "direction": RhythmNote.Direction.DOWN},
		{"offset": 3.0, "direction": RhythmNote.Direction.LEFT},
		{"offset": 3.5, "direction": RhythmNote.Direction.RIGHT}
	],

	# Zig-zag
	[
		{"offset": 0.0, "direction": RhythmNote.Direction.LEFT},
		{"offset": 0.5, "direction": RhythmNote.Direction.DOWN},
		{"offset": 1.0, "direction": RhythmNote.Direction.UP},
		{"offset": 1.5, "direction": RhythmNote.Direction.RIGHT},
		{"offset": 2.0, "direction": RhythmNote.Direction.UP},
		{"offset": 2.5, "direction": RhythmNote.Direction.DOWN},
		{"offset": 3.0, "direction": RhythmNote.Direction.LEFT}
	]
]


func _ready() -> void:
	seconds_per_beat = 60.0 / bpm

	randomize()
	queue_random_pattern()

	music.set_paused(false)

	perfect_sprite.visible = false
	great_sprite.visible = false
	good_sprite.visible = false
	miss_sprite.visible = false


func _process(delta: float) -> void:
	if fmod_playing:
		song_time += delta

	spawn_pending_notes()
	update_notes()
	check_input()
	check_misses()


# ============================================
# INPUT
# ============================================

func check_input() -> void:
	if Input.is_action_just_pressed("ui_left"):
		try_hit_note(RhythmNote.Direction.LEFT)

	if Input.is_action_just_pressed("ui_down"):
		try_hit_note(RhythmNote.Direction.DOWN)

	if Input.is_action_just_pressed("ui_up"):
		try_hit_note(RhythmNote.Direction.UP)

	if Input.is_action_just_pressed("ui_right"):
		try_hit_note(RhythmNote.Direction.RIGHT)


func try_hit_note(direction: RhythmNote.Direction) -> void:
	var closest_note: RhythmNote = null
	var closest_difference: float = INF

	for child in notes_container.get_children():

		if child is RhythmNote:
			var note: RhythmNote = child

			if note.direction != direction:
				continue

			var difference: float = abs(
				note.hit_time - song_time
			)

			if difference < closest_difference:
				closest_difference = difference
				closest_note = note


	if closest_note == null:
		show_feedback("MISS")
		score_manager.update_score(score_manager.score_miss)
		return


	if closest_difference <= perfect_window:

		show_feedback("PERFECT")
		score_manager.update_score(score_manager.score_perfect)

		closest_note.queue_free()


	elif closest_difference <= great_window:

		show_feedback("GREAT")
		score_manager.update_score(score_manager.score_great)

		closest_note.queue_free()


	elif closest_difference <= good_window:

		show_feedback("GOOD")
		score_manager.update_score(score_manager.score_good)

		closest_note.queue_free()


	else:
		show_feedback("MISS")
		score_manager.update_score(score_manager.score_miss)


# ============================================
# FEEDBACK
# ============================================

func show_feedback(result: String) -> void:

	perfect_sprite.visible = false
	great_sprite.visible = false
	good_sprite.visible = false
	miss_sprite.visible = false

	match result:

		"PERFECT":
			perfect_sprite.visible = true

		"GREAT":
			great_sprite.visible = true

		"GOOD":
			good_sprite.visible = true

		"MISS":
			miss_sprite.visible = true


	await get_tree().create_timer(0.3).timeout

	perfect_sprite.visible = false
	great_sprite.visible = false
	good_sprite.visible = false
	miss_sprite.visible = false


func check_misses() -> void:

	for child in notes_container.get_children():

		if child is RhythmNote:
			var note: RhythmNote = child

			if song_time > note.hit_time + good_window:

				show_feedback("MISS")

				score_manager.update_score(
					score_manager.score_miss
				)

				note.queue_free()


# ============================================
# PATRONES
# ============================================

func queue_random_pattern() -> void:

	var pattern

	if second_half:
		pattern = patterns_second_half.pick_random()
	else:
		pattern = patterns_first_half.pick_random()


	var pattern_length: float = 0.0


	for note_data in pattern:

		var offset: float = float(note_data["offset"])

		var note_beat: float = (
			next_pattern_beat + offset
		)

		pending_notes.append({
			"beat": note_beat,
			"direction": note_data["direction"]
		})

		pattern_length = max(
			pattern_length,
			offset
		)


	next_pattern_beat += (
		pattern_length
		+ 1.0
		+ pattern_gap_beats
	)


func spawn_pending_notes() -> void:

	if pending_notes.is_empty():
		queue_random_pattern()
		return


	var note_data = pending_notes[0]


	var hit_time: float = (
		note_data["beat"]
		* seconds_per_beat
	)


	var spawn_time: float = (
		hit_time
		- travel_time
	)


	if song_time >= spawn_time:

		create_note(
			note_data["direction"],
			hit_time
		)

		pending_notes.pop_front()


		if pending_notes.is_empty():
			queue_random_pattern()


# ============================================
# CREACIÓN / MOVIMIENTO DE NOTAS
# ============================================

func create_note(
	direction: RhythmNote.Direction,
	hit_time: float
) -> void:

	var note: RhythmNote = note_scene.instantiate()

	notes_container.add_child(note)

	note.setup(
		direction,
		hit_time,
		spawn_y,
		target_y,
		travel_time
	)


func update_notes() -> void:

	for note in notes_container.get_children():

		if note is RhythmNote:
			note.update_note(song_time)


# ============================================
# FMOD
# ============================================

func _on_fmod_event_emitter_2d_timeline_beat(
	params: Dictionary
) -> void:

	var position_ms: int = params["position"]

	song_time = position_ms / 1000.0
	fmod_playing = true


	# Detectamos la mitad de la canción.
	if !second_half and song_time >= song_duration / 2.0:

		second_half = true

		print("=======================")
		print("SEGUNDA MITAD")
		print("NUEVOS PATRONES")
		print("=======================")


	print(
		"FMOD | Bar: ", params["bar"],
		" Beat: ", params["beat"],
		" Time: ", song_time
	)
