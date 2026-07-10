extends CharacterBody2D

@onready var escudo_area = $Area_Escudo
@export var bullet : Area2D
@onready var escudo_anim_1 = $Area_Escudo/Escudo
@onready var escudo_anim_2 = $Area_Escudo/Escudo2
@onready var escudo_collision = $"Area_Escudo/CollisionShape2D"
@onready var timer = $Timer
@onready var life_component = $"Health Component"
@onready var life_bar = $"Health Component/CanvasGroup/ProgressBar"
@export var dog_power : Area2D
@export var damage_dog := 30
@export var game_manager : Node2D
@onready var anim_boss = $AnimatedSprite2D
var escudo_active = true
@export var life := 100
var life_70 = false
var life_50 = false
var life_25 = true
var hurt = false
func _ready() -> void:
	life_bar.max_value = life
	life_bar.value = life
	bullet.shoot_done.connect(_on_shoot_done)
	escudo_anim_1.play()
	escudo_anim_2.play()
	anim_boss.play("idle")
	life_component.life_70.connect(_on_life_70)
	life_component.life_50.connect(_on_life_50)
	life_component.life_25.connect(_on_life_25)
func _on_shoot_done():
	escudo_area.set_deferred("monitoring", false)
	escudo_collision.set_deferred("disabled", true)
	escudo_anim_1.visible = false
	escudo_anim_2.visible = false
	escudo_active = false
	timer.start()
func _on_timer_timeout() -> void:
	escudo_area.set_deferred("monitoring", true)
	escudo_anim_1.visible = true
	escudo_anim_2.visible = true
	escudo_collision.set_deferred("disabled", false)
	escudo_active = true

func _on_life_70():
	if (!life_70):
		life_70  = true
		dog_power.dog_power()
		escudo_active = true
		escudo_area.set_deferred("monitoring", true)
		escudo_anim_1.visible = true
		escudo_anim_2.visible = true
		escudo_collision.set_deferred("disabled", false)
		if (!game_manager.round_2):
			game_manager.deactivate_boss_bullets()
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet") and !escudo_active:
		if !hurt:
			hurt = true

			life_component.get_hurt()
			life_bar.value = life_component.get_life()

			await get_tree().create_timer(1.2).timeout

			hurt = false
func _on_life_50():
	if (!life_50):
		dog_power.dog_power()
		game_manager.increase_bullets_speed()
		game_manager.increase_dog_power_speed()
		life_50 = true
func _on_life_25():
	if !life_25:
		dog_power.dog_power()
		game_manager.increase_bullets_speed()
		game_manager.increase_dog_power_speed()
		life_25 = true
