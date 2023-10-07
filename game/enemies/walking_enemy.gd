extends CharacterBody2D

const SPEED = 50.0

var direction = 1 # right

@export var can_move = true

func _ready():
	set_physics_process(can_move)

func _physics_process(_delta):
	if true in [
		$RayCast2D_right.is_colliding(),
		$RayCast2D_left.is_colliding(),
		!$RayCast2D_ledger_right.is_colliding(),
		!$RayCast2D_ledger_left.is_colliding()
	]: direction *= -1
	
	$AnimatedSprite2D.flip_h = direction > 0
	velocity.x = direction * SPEED
	
	move_and_slide()

func move():
	can_move = true
	set_physics_process(true)
