extends Area2D
@onready var collision = $CollisionShape2D
@export var building: Sprite2D
@onready var sprite = $Sprite2D
signal jeroglifico_taken
@export var sprite_texture: Texture2D
func _ready() -> void:
	visible = false
	sprite.texture = sprite_texture
	building.building_destroyed.connect(set_jero_visible)
func set_jero_visible():
	visible = true
	print("set jero visible llamado")




func _on_body_entered(body: Node2D) -> void:
	print ("algo entro")
	if body.is_in_group("player"):
		print ("tocamos el jeroglifico")
		jeroglifico_taken.emit()
		queue_free()
