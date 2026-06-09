extends Node2D

@onready var timer = $Timer
@onready var timer_2 = $Timer2
@export var marker_1 : Marker2D
@export var marker_2 : Marker2D
var count_1 = 0
var count_2 = 0
var i = 0
var j = 0
@export var enemy :Array[CharacterBody2D]
@export var enemy_2 :Array[CharacterBody2D]


func _on_timer_timeout() -> void:
	count_1 += 1
func spawn_1():
	if count_1 >= 5 and i < enemy.size():
		enemy[i].visible = true
		enemy[i].process_mode = Node.PROCESS_MODE_INHERIT
		enemy[i].global_position = marker_1.global_position
		count_1 = 0
		i += 1
func spawn_2():
	if count_2 >= 7 and j < enemy_2.size():
		enemy_2[j].visible = true
		enemy_2[j].process_mode = Node.PROCESS_MODE_INHERIT
		enemy_2[j].global_position = marker_2.global_position
		count_2 = 0
		j += 1

func _on_timer_2_timeout() -> void:
	count_2 += 1
func _ready() -> void:
		enemy[0].proces.mode = Node.PROCESS_MODE_DISABLED
		enemy[0].visible = false
		enemy[1].proces.mode = Node.PROCESS_MODE_DISABLED
		enemy[1].visible = false
		enemy[2].proces.mode = Node.PROCESS_MODE_DISABLED
		enemy[2].visible = false
		enemy[3].proces.mode = Node.PROCESS_MODE_DISABLED
		enemy[3].visible = false
		enemy[4].proces.mode = Node.PROCESS_MODE_DISABLED
		enemy[4].visible = false
		enemy[5].proces.mode = Node.PROCESS_MODE_DISABLED
		enemy[5].visible = false
