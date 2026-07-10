extends CanvasGroup
@export var life = 100
@onready var progress_bar = $ProgressBar

func get_life():
	return life
func reset_life():
	life = 100
func take_damage(damage):
	life -= damage
	progress_bar.value = life
	life = clamp(life, 0, 100)
