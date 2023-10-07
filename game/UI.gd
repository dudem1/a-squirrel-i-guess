extends CanvasLayer

var tween_hide_btns

func _ready():
	if Global.used_touchscreen: showTouchBtns()

func _input(event):
	if event is InputEventScreenTouch:
		Global.used_touchscreen = true
		if tween_hide_btns: tween_hide_btns.stop()
		showTouchBtns()
	
	Global.used_touchscreen = not event is InputEventKey

func _on_timer_timeout():
	tween_hide_btns = create_tween()
	tween_hide_btns.tween_property($Control_touchsceen, "modulate:a", 0, 2)

func showTouchBtns():
	$Control_touchsceen.modulate.a = 0.5
	$Control_touchsceen/Timer.start()
	
