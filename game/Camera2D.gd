extends Camera2D

var shake_amount = 1.0
var current_offset = offset

func _ready():
	set_process(false)

func _process(_delta):
	set_offset(Vector2(
		current_offset.x + randf_range(-1.0, 1.0) * shake_amount,
		randf_range(-1.0, 1.0) * shake_amount
	))
	
	if $Timer_shake.is_stopped():
		set_offset(current_offset)
		set_process(false)

func shake():
	set_process(true)
	$Timer_shake.start()
