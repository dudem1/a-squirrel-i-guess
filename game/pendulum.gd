extends CharacterBody2D

var delay = 0.5
var angle = 0.5
@export var start_swing = 1

func _ready():
	var tween_move = create_tween().set_loops().set_trans(Tween.TRANS_CUBIC)
	tween_move.tween_property(self, "rotation",  angle * start_swing, delay).set_ease(Tween.EASE_OUT)
	tween_move.tween_property(self, "rotation",  0, delay).set_ease(Tween.EASE_IN)
	tween_move.tween_property(self, "rotation",  -angle * start_swing, delay).set_ease(Tween.EASE_OUT)
	tween_move.tween_property(self, "rotation",  0, delay).set_ease(Tween.EASE_IN)
