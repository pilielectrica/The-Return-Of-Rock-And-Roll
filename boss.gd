extends CharacterBody2D

@onready var escudo_area = $Area_Escudo
@export var bullet : Area2D
@onready var escudo_anim_1 = $Area_Escudo/Escudo
@onready var escudo_anim_2 = $Area_Escudo/Escudo2
@onready var escudo_collision = $"Perro Area 2D/CollisionShapePerro"
@onready var timer = $Timer
@onready var life_component = $"Health Component"
@onready var life_bar = $"Health Component/CanvasGroup/ProgressBar"
func _ready() -> void:
	bullet.shoot_done.connect(_on_shoot_done)
	escudo_anim_1.play()
	escudo_anim_2.play()
func _on_shoot_done():
	escudo_area.set_deferred("monitoring", false)
	escudo_collision.set_deferred("disabled", true)
	escudo_anim_1.visible = false
	escudo_anim_2.visible = false
	timer.start()
func _on_timer_timeout() -> void:
	escudo_area.set_deferred("monitoring", true)
	escudo_anim_1.visible = true
	escudo_anim_2.visible = true
	escudo_collision.set_deferred("disabled", false)


func _on_perro_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		life_component.get_hurt()
		life_bar.value -= life_component.get_life()
