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
var direction : Vector2
@export var speed := 500
@export var player_marker : Marker2D
@onready var start_position
var calculation = false
var attack = false
var attacking = false
@export var target_pos : Area2D
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
	start_position = global_position
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
			life_component.get_hurt()
			hurt = true
		life_bar.value = life_component.get_life()
		melee_attack()
	if area == target_pos:
		velocity = Vector2.ZERO
		anim_boss.play("attack_1")
		await get_tree().create_timer(2.0).timeout
		finish_melee_attack()
func _on_life_50():
	if (!life_50):

		game_manager.increase_dog_power_speed()
		life_50 = true
func _on_life_25():
	if !life_25:
		game_manager.increase_dog_power_speed()
		life_25 = true
func melee_attack():
	target_pos.global_position = player_marker.global_position
	if !calculation:
		direction = (player_marker.global_position - global_position).normalized()
		direction = direction.normalized()
		velocity = direction * speed
		anim_boss.play("move")
		calculation = true
		attack = true
func _physics_process(delta: float) -> void:
	if (attack):
		move_and_slide()

func finish_melee_attack():
		global_position = start_position
		calculation = false
		attack = false
		anim_boss.play("idle")
		dog_power.dog_power()
		game_manager.increase_bullets_speed()
