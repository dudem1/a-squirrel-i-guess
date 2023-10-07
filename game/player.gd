extends CharacterBody2D
class_name Player

const SPEED = 150.0
const JUMP_VELOCITY = -250.0

var prev_direction = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var freezed = true
var died = false
var born = true
var direction
var spring = false
var is_on_spring = false
var is_touchscreen = false
var is_touch = false
var finished = false
var firework_colors = [Color(255,0,0), Color(255,128,0), Color(255,255,0), Color(128,255,0), Color(0,255,0), Color(0,255,128), Color(0,255,255), Color(0,128,255), Color(0,0,255), Color(128,0,255), Color(255,0,255), Color(255,0,128)]
var rng = RandomNumberGenerator.new()

@onready var born_rect = $"../UI/ColorRect_born"
@onready var firework = $"../Area2D_finish/CPUParticles2D_firework"

func _ready():
	visible = false

func _physics_process(delta):
	if born: bornFunction()
	
	if position.y > 180 and !freezed:
		freezed = true
		velocity.x = 0
	
	if position.y > 500:
		born_rect.position.y = -360
		var tween_born_rect = create_tween().set_ease(Tween.EASE_OUT)
		tween_born_rect.tween_property(born_rect, "position:y", 0, 0.2)
		tween_born_rect.connect("finished", on_tween_born_rect_finished)
	
	velocity.y = min(velocity.y, 300)
	
	if freezed:
		if is_on_floor() and !died:
			freezed = false
			$Camera2D.position_smoothing_enabled = true
	else:
		direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			$AnimatedSprite2D.animation = "Run"
			if prev_direction != direction: scale.x = -1
			prev_direction = direction
			velocity.x = direction * SPEED
		else:
			$AnimatedSprite2D.animation = "Idle"
			velocity.x = move_toward(velocity.x, 0, SPEED / 3)
	
	if spring:
		jumpFromSpring()
	elif is_on_floor():
		is_on_spring = false
		if Input.is_action_just_pressed("ui_accept") or (is_touchscreen and is_touch):
			velocity.y = JUMP_VELOCITY
			SoundController.playSound(SoundController.jump)
	else:
		if !freezed: $AnimatedSprite2D.animation = "Jump"
		velocity.y += gravity * delta
		
		if (Input.is_action_just_released("ui_accept") or (is_touchscreen and !is_touch and !is_on_spring)) and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
	
	if $AnimatedSprite2D.animation == "Run" and !freezed: $CPUParticles2D_run.emitting = true
	
	move_and_slide()

func jumpFromSpring():
	spring = false
	is_on_spring = true
	velocity.y = JUMP_VELOCITY * 1.5
	SoundController.playSound(SoundController.jump, 0.6)

func hurt():
	freezed = true
	died = true
	$CPUParticles2D_run.emitting = false
	$AnimatedSprite2D.animation = "Hurt"
	$CollisionShape2D.call_deferred("set_disabled", true)
	SoundController.playSound(SoundController.hurt)
	$Camera2D.shake()
	velocity.x = prev_direction * JUMP_VELOCITY / 2
	velocity.y = JUMP_VELOCITY

func bornFunction():
	born = false
	Global.checkpoint()
	$CPUParticles2D_born.emitting = true
	$Camera2D.position_smoothing_enabled = false
	Input.action_release("ui_left")
	Input.action_release("ui_right")
	Input.action_release("ui_accept")
	SoundController.playSound(SoundController.born)
	var tween_born_rect = create_tween().set_ease(Tween.EASE_OUT)
	tween_born_rect.tween_property(born_rect, "position:y", position.y + 360, 0.3)

func on_tween_born_rect_finished():
	get_tree().reload_current_scene()

func toggleInput(key, event):
	if event is InputEventScreenTouch:
		if event.pressed: Input.action_press(key)
		else: Input.action_release(key)

func _on_texture_button_left_gui_input(event):
	toggleInput("ui_left", event)

func _on_texture_button_right_gui_input(event):
	toggleInput("ui_right", event)

func _on_texture_button_jump_gui_input(event):
	toggleInput("ui_accept", event)
	if event is InputEventScreenTouch: is_touch = event.pressed

func _input(event):
	is_touchscreen = event is InputEventScreenTouch

func _on_area_2d_finish_body_entered(body):
	if body is Player:
		$"../Area2D_finish/StaticBody2D/CollisionShape2D".call_deferred("set_disabled", false)

func _on_checkpoint_finish_body_entered(body):
	if body is Player and !finished:
		finished = true
		$Camera2D.limit_left = 3118
		Global.stopPlayTime()
		$"../UI/TopPanel/hourglass".stop()
		$"../UI/TopPanel/hourglass".frame = 0
		var tween_top_panel = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween_top_panel.tween_property($"../UI/TopPanel", "position",  Vector2(get_viewport().get_visible_rect().size.x - 200, 66), 1)
		$"../Area2D_finish/Timer_firework".start()

func _on_timer_firework_timeout():
	firework.emitting = true
	firework.position = Vector2(rng.randi_range(0, 198), rng.randi_range(-144, -90))
	firework.color = firework_colors[rng.randi_range(0, firework_colors.size() - 1)]
	SoundController.playSound(SoundController.firework)
