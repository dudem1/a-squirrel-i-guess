extends StaticBody2D

func _on_area_2d_body_entered(body):
	if body is Player:
		$AnimatedSprite2D.frame = 1
		$AnimatedSprite2D.play()
		body.spring = true
	
