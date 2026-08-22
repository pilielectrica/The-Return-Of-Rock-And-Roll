extends RigidBody2D

@export var collider : Area2D
@onready var collider_estatua = $CollisionShape2D
@onready var anim = $AnimatedSprite2D
@export var barrera : CollisionShape2D
@export var flip_h := false
@export var pos_offset := 40
var done = false
func _ready() -> void:
	collider.body_entered.connect(_on_collider_enter)
	anim.flip_h = flip_h
	anim.play("default")
	if flip_h :
		collider_estatua.position.x += 70
func _on_collider_enter(body):
	if (!done):
		if body.is_in_group("player"):
			anim.play("block")
			position.x += pos_offset
			barrera.set_deferred("disabled", false)
			done = true
