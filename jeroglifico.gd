extends Area2D
@onready var collision = $CollisionShape2D
@export var building: Sprite2D
@onready var sprite = $Sprite2D
signal jeroglifico_taken
@export var sprite_texture: Texture2D
var jero_count = 0
signal free_shooter_mummies
func _ready() -> void:
	visible = false
	sprite.texture = sprite_texture
	collision.set_deferred("disabled", true)
	if (building != null):
		building.building_destroyed.connect(set_jero_visible)
func set_jero_visible():
	collision.set_deferred("disabled", false)
	visible = true
	print("set jero visible llamado")
func _on_body_entered(body: Node2D) -> void:
	print ("algo entro")
	if body.is_in_group("player"):
		print ("tocamos el jeroglifico")
		jeroglifico_taken.emit()
		queue_free()
