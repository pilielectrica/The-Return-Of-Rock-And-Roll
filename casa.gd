extends Sprite2D

var destroy := 0
@export var max_hits := 20
@export var hits_per_fire := 4

@export var sprites: Array[AnimatedSprite2D]
@export var markers: Array[Marker2D]
@export var explosion: AnimatedSprite2D
signal building_destroyed
signal building_hit
func _ready() -> void:
	for fire in sprites:
		fire.visible = false
		fire.stop()
		explosion.visible = false
		explosion.stop()
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		destroy += 1
		count_bullets()

func count_bullets():
	var fire_count := destroy / hits_per_fire
	if (destroy >=1):
		building_hit.emit()
	for i in range(sprites.size()):
		if i < fire_count and i < markers.size():
			sprites[i].visible = true
			sprites[i].global_position = markers[i].global_position
			sprites[i].play("default")
		else:
			sprites[i].visible = false
			sprites[i].stop()

	if destroy >= max_hits:
		building_destroyed.emit()
		explosion.visible = true
		explosion.play("default")
		await get_tree().create_timer(3).timeout
		queue_free()
