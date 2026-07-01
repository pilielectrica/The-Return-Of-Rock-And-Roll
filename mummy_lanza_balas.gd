extends Area2D
@export var bullet_mummy: Area2D
@export var marker: Marker2D
@onready var timer = $Timer
@export var player: CharacterBody2D
@onready var sprite = $Sprite2D
@export var building: Sprite2D
@onready var timer_on = false
@onready var signalrecieved = false
func _ready() -> void:
	building.free_shooter_mummies.connect(activate_mummies)

func activate_mummies():
	signalrecieved = true
	if sprite.visible:
		sprite.visible = false
		timer.wait_time = 5
	else:
		sprite.visible = true
		bullet_mummy.shoot(marker.global_position, player)
		timer.wait_time = 5

func _on_timer_timeout():
	if (signalrecieved):
		activate_mummies()
