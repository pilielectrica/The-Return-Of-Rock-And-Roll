extends StaticBody2D

@onready var texture_guitar : Texture2D
@export var jeroglifico_1: Area2D
@export var jeroglifico_2: Area2D
@export var jeroglifico_3: Area2D
@export var jeroglifico_4: Area2D
@onready var guitar_sprite = $Sprite_Guitar_1
@export var player : CharacterBody2D
@export var green_effect : AnimatedSprite2D
var guitar_free = false
signal guitar_free_signal
func _ready() -> void:
	jeroglifico_1.jeroglifico_taken.connect(show_guitar_1)
	jeroglifico_2.jeroglifico_taken.connect(show_guitar_2)
	jeroglifico_3.jeroglifico_taken.connect(show_guitar_3)
#	jeroglifico_4.jeroglifico_taken.connect(show_guitar_4)
func show_guitar_1():
	player.input_enabled = false
	guitar_sprite.texture = preload("res://guitarra 2.png")
	player.get_child(2).global_position = global_position
	await get_tree().create_timer(2.0).timeout
	player.get_child(2).global_position = player.global_position
	player.input_enabled = true
func show_guitar_2():
	guitar_sprite.texture = preload("res://guitarra 3.png")
func show_guitar_3():
	guitar_sprite.texture = preload("res://guitarra 4.png")
	guitar_free = true
	green_effect.visible = true
	green_effect.play("default")
func _on_area_2d_area_entered(area: Area2D) -> void:
	if guitar_free:
		guitar_free_signal.emit()
