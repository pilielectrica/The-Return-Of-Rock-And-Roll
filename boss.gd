extends CharacterBody2D

@onready var escudo_area = $Area_Escudo
@export var bullet : Area2D
@onready var escudo_anim_1 = $Area_Escudo/Escudo
@onready var escudo_anim_2 = $Area_Escudo/Escudo2
@onready var timer = $Timer
func _ready() -> void:
	bullet.shoot_done.connect(_on_shoot_done)
	escudo_anim_1.play()
	escudo_anim_2.play()
func _on_shoot_done():
	escudo_area.set_deferred("monitoring", false)
	escudo_anim_1.visible = false
	escudo_anim_2.visible = false
	timer.start()
func _on_timer_timeout() -> void:
	escudo_area.set_deferred("monitoring", true)
	escudo_anim_1.visible = true
	escudo_anim_2.visible = true
