extends Area2D

func _ready():
	check(false)

func _on_body_entered(body):
	if body is Player and $AnimatedSprite2D.animation == "Unchecked":
		Global.checked_checkpoint_name = name
		Global.checkpoint_collected_coin_names = [] + Global.collected_coin_names
		Global.checkpoint_collected_door_and_key_names = [] + Global.collected_door_and_key_names
		$CPUParticles2D.emitting = true
		for i in Global.checkpoints: i.check(false)
		check()
		SoundController.playSound(SoundController.checkpoint)

func check(value = true):
	if value:
		$AnimatedSprite2D.animation = "Checked"
	else:
		$AnimatedSprite2D.animation = "Unchecked"
