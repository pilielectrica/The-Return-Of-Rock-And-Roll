extends Area2D
@export var bullet_mummy: Area2D
@export var marker: Marker2D
@onready var timer = $Timer
@export var player: CharacterBody2D
@onready var sprite = $Sprite2D
@export var house_2: Sprite2D
@export var house_actual: Sprite2D
@onready var timer_on = false
@onready var signalrecieved = false
@export var time_appear := 5
@export var time_disappear := 5
@onready var health = $"Sprite2D/Health Component"
@onready var health_bar = $"Sprite2D/Health Component/CanvasGroup/ProgressBar"
@onready var collider = $CollisionShape2D
var killed = false
var done = false
@onready var actual_house_destroyed = false
signal die
func _ready() -> void:
	house_2.free_shooter_mummy.connect(activate_mummy)
func activate_mummy():
	signalrecieved = true
	if sprite.visible:
		sprite.visible = false
		timer.wait_time = time_appear
		collider.disabled = true
	else:
		sprite.visible = true
		bullet_mummy.shoot(marker.global_position, player)
		timer.wait_time = time_disappear
		collider.disabled = false

func _on_timer_timeout():
	if (signalrecieved):
		activate_mummy()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		health.get_hurt()
		health_bar.value = health.get_life()
		if health.get_life() <= 0:
			deactivate_mummy()
			if (!done):
				die.emit()
				done = true
func deactivate_mummy():
		process_mode = Node.PROCESS_MODE_DISABLED
		sprite.visible = false
		collider.disabled = true
		bullet_mummy.visible = false
		bullet_mummy.process_mode = Node.PROCESS_MODE_DISABLED
		actual_house_destroyed = true
		
