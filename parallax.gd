extends Node2D

@onready var sky: Parallax2D = $Parallax2D
@onready var clouds: Parallax2D = $Parallax2D2
@onready var far: Parallax2D = $Parallax2D3
@onready var near: Parallax2D = $Parallax2D4
@onready var synth : Parallax2D = $Parallax2D5
@export var sky_speed := 3.0
@export var clouds_speed := 2.0
@export var far_speed := 15.0
@export var near_speed := 25.0

func _ready() -> void:
	var screen_size := get_viewport().get_visible_rect().size
	var design_size := Vector2(1152, 648)
	get_parent().position = (screen_size - design_size) / 2.0

func _process(delta: float) -> void:
	sky.scroll_offset.x += sky_speed * delta
	clouds.scroll_offset.x += clouds_speed * delta
	far.scroll_offset.x += far_speed * delta
	near.scroll_offset.x += near_speed * delta
