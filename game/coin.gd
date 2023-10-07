extends Area2D

var collected = false

func _on_body_entered(body):
	if body is Player and !collected:
		collected = true
		SoundController.playSound(SoundController.coin)
		Global.addCoin(name)
		var tween_position = create_tween()
		var tween_modulate_a = create_tween().set_ease(Tween.EASE_OUT)
		tween_position.tween_property(self, "position:y", position.y - 20, 0.2)
		tween_position.tween_property(self, "position:y", position.y + 20, 0.2)
		tween_modulate_a.tween_property(self, "modulate:a", 0, 0.3)
		tween_position.connect("finished", on_tween_position_finished)

func on_tween_position_finished():
	queue_free()
