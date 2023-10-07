extends StaticBody2D

var is_sinking = false

@onready var start_position_y = position.y

func _ready():
	var tween_position = create_tween().set_loops().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween_position.tween_property(self, "position:y",  start_position_y + 2, 0.5)
	tween_position.tween_property(self, "position:y",  start_position_y, 0.5)

func _process(_delta):
	if position.y > start_position_y + 50:
		is_sinking = false
		$CollisionShape2D.disabled = true
	elif position.y < start_position_y + 10:
		$CollisionShape2D.disabled = false

func _on_area_2d_body_entered(body):
	if body is Player and !is_sinking: $Timer.start()

func _on_timer_timeout():
	is_sinking = true
	var tween_sinking = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween_sinking.tween_property(self, "position:y",  start_position_y + 50, 1)
	tween_sinking.tween_property(self, "position:y",  start_position_y, 0.3)
