extends AnimatedSprite2D

func _ready():
	play("default")
func _process(delta: float) -> void:
	if (frame == 14):
		queue_free()
