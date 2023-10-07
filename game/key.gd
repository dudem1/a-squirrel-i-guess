extends Area2D

var collected = false

func _on_body_entered(body):
	if body is Player and !collected:
		collected = true
		Global.collected_door_and_key_names.append(get_parent().name)
		SoundController.playSound(SoundController.key)
		var tween_position = create_tween().set_trans(Tween.TRANS_EXPO)
		var tween_modulate_a = create_tween().set_trans(Tween.TRANS_EXPO)
		tween_position.tween_property(self, "position",  get_parent().get_child(0).position, 0.5)
		tween_modulate_a.tween_property(self, "modulate:a", 0, 0.5)
		tween_position.connect("finished", on_tween_position_finished)

func on_tween_position_finished():
	get_parent().queue_free()
