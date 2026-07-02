extends CanvasGroup
@export var jeroglifico_1: Area2D
@export var jeroglifico_2: Area2D
@export var jeroglifico_3: Area2D
@export var jeroglifico_4: Area2D
var count_jero = 0
@onready var button_1 = $CanvasLayer/Control/Button/PanelContainer2
@onready var button_2 = $CanvasLayer/Control/Button2/PanelContainer3
@onready var button_3 = $CanvasLayer/Control/Button3/PanelContainer4
@onready var button_4 = $CanvasLayer/Control/Button4/PanelContainer5
func _ready() -> void:
	jeroglifico_1.jeroglifico_taken.connect(enable_jero_1)
	jeroglifico_2.jeroglifico_taken.connect(enable_jero_2)
	jeroglifico_3.jeroglifico_taken.connect(enable_jero_3)
	#jeroglifico_4.jeroglifico_taken.connect(enable_jero_4)
func enable_jero_1():
	button_1.visible = false
func enable_jero_2():

	button_2.visible = false
func enable_jero_3():

	button_3.visible = false
func enable_jero_4():
	button_4.visible = false
