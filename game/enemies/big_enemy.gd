extends CharacterBody2D
class_name BigEnemy

const SPEED = 145.0 # 150 = player speed

func _ready():
	set_physics_process(false)

func _physics_process(_delta):
	velocity.x = SPEED
	move_and_slide()

func _on_area_2d_wakeup_body_entered(body):
	if body is Player:
		$AnimatedSprite2D.animation = "Walking"
		$AnimatedSprite2D.stop()

func _on_area_2d_start_body_entered(body):
	if body is Player:
		$AnimatedSprite2D.play()
		$CollisionShape2D.call_deferred("set_disabled", true)
		set_physics_process(true)
		
		for i in $"../../WalkingEnemy".get_children(): i.move()
		for i in $"../../JumpingFish".get_children(): i.move()

func _on_area_2d_stop_area_entered(area):
	if area.name == "Area2D_wakeup": set_physics_process(false)
