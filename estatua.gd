extends RigidBody2D

@export var collider : Area2D
@onready var anim = $AnimatedSprite2D
@export var barrera : CollisionShape2D
@export var flip_h := false
@export var pos_offset := 20
var done = false
func _ready() -> void:
	collider.body_entered.connect(_on_collider_enter)
	anim.flip_h = flip_h
func _on_collider_enter(body):
	if (!done):
		if body.is_in_group("player"):
			anim.play("block")
			anim.position.x += pos_offset
			barrera.set_deferred("disabled", false)
			done = true
