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
@export var speed_increasement := 100
@export var player_marker : Marker2D
@onready var start_position
var calculation = false
var attack = false
var attacking = false
var rounds_count = 0
@export var bullet_manager : Node2D
@export var target_pos : Area2D
var dash_target := Vector2.ZERO
var collision = get_slide_collision(0)
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
	anim_boss.animation_finished.connect(_on_attack_anim_finished)
func _on_shoot_done():
	escudo_area.set_deferred("monitoring", false)
	escudo_collision.set_deferred("disabled", true)
	escudo_anim_1.visible = false
	escudo_anim_2.visible = false
	escudo_active = false
	timer.start()
	rounds_count += 1

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
		print("BALA IMPACTÓ: ", area.name)
		print(
	"BALA IMPACTÓ: ",
	area.name,
	" | path: ",
	area.get_path(),
	" | instance id: ",
	area.get_instance_id()
)
		if !area.active:
			return
		life_component.get_hurt()
		dash_attack()
		if area.has_method("deactivate"):
			area.deactivate()
		life_bar.value = life_component.get_life()
func _on_life_50():
	if (!life_50):
		game_manager.increase_dog_power_speed()
		life_50 = true
func _on_life_25():
	if !life_25:
		game_manager.increase_dog_power_speed()
		life_25 = true


func dash_attack():
	if calculation:
		return

	dash_target = player_marker.global_position

	direction = (dash_target - global_position).normalized()
	velocity = direction * speed

	anim_boss.play("move")

	calculation = true
	attack = true

func _physics_process(delta: float) -> void:
	if attack:
		print(global_position.distance_to(dash_target))
		move_and_slide()
		
		var collision = null

		if get_slide_collision_count() > 0:
			collision = get_slide_collision(0)

		if global_position.distance_to(dash_target) <= 500.0:
			anim_boss.play("attack_1")

		if collision != null and not collision.get_collider() is CharacterBody2D:
			velocity = Vector2.ZERO
			attack = false

func finish_dash_attack():
		global_position = start_position
		calculation = false
		attack = false
		anim_boss.play("idle")
		dog_power.dog_power()
		game_manager.increase_bullets_speed()
		speed += speed_increasement
		hurt = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(10)
		print ("enemy toco a player")
		velocity = Vector2.ZERO
		attack = false



func _on_attack_anim_finished():
	if anim_boss.animation == "attack_1":
		anim_boss.play("idle")
		await get_tree().create_timer(2.0).timeout
		finish_dash_attack()
