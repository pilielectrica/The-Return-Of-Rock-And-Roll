extends Sprite2D

var destroy := 0
@export var max_hits := 20
@export var hits_per_fire := 4

@export var sprites: Array[AnimatedSprite2D]
@export var markers: Array[Marker2D]
@export var explosion: AnimatedSprite2D
signal building_destroyed
signal building_hit
signal free_shooter_mummy
@export var house_2 = false
@export var house_shooters = false
@export var music_manager : Node2D
var sound_played = false
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
		music_manager.play_Part_B_Level_1()
	for i in range(sprites.size()):
		if i < fire_count and i < markers.size():
			sprites[i].visible = true
			sprites[i].global_position = markers[i].global_position
			sprites[i].play("default")
			if (!sound_played):
				$FmodEventEmitter2D.play()
				sound_played = true
		else:
			sprites[i].visible = false
			sprites[i].stop()

	if destroy >= max_hits:
		building_destroyed.emit()
		explosion.visible = true
		explosion.play("default")
		await get_tree().create_timer(2).timeout
		music_manager.play_Part_C_Level_1()
		if (house_2):
			free_shooter_mummy.emit()
			music_manager.play_Part_D_Level_1()
		queue_free()
	
