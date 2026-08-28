extends Node2D

var score = 0
var score_perfect = 100
var score_great = 75
var score_good = 50
var score_miss = 0
@onready var score_text = $Score_Text
func update_score(_score):
	score += _score
func show_score():
	score_text.text = str(score)
func _process(delta: float) -> void:
	show_score()
