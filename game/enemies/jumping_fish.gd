extends CharacterBody2D

const JUMP_VELOCITY = -500.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var can_move = true

func _ready():
	set_physics_process(can_move)

func _physics_process(delta):
	velocity.y += gravity * delta
	
	$AnimatedSprite2D.flip_v = velocity.y > 0

	if position.y > 200: velocity.y = JUMP_VELOCITY

	move_and_slide()

func move():
	can_move = true
	set_physics_process(true)
