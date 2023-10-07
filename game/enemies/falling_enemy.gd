extends Node2D

enum {FALL, LAND, RISE}

var state = RISE

@onready var start_position = global_position
@onready var timer: = $Timer
@onready var raycast_ground: = $RayCast2D_ground
@onready var sprite: = $Sprite2D
@onready var particles: = $CPUParticles2D

func _physics_process(delta):
	match state:
		FALL: fallState(delta)
		LAND: landState()
		RISE: riseState(delta)
		
func hoverState():
	state = FALL

func fallState(delta):
	sprite.frame = 1
	position.y += position.y * 1.5 * delta
	if raycast_ground.is_colliding():
		var collision_point = raycast_ground.get_collision_point()
		position.y = collision_point.y
		state = LAND
		timer.start()
		particles.emitting = true

func landState():
	if timer.is_stopped(): state = RISE

func riseState(delta):
	sprite.frame = 0
	position.y = move_toward(position.y, start_position.y, 70 * delta)

func _on_area_2d_body_entered(body):
	if body is Player and position.y == start_position.y: state = FALL
