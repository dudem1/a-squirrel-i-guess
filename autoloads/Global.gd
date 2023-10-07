extends Node

var collected_coin_names = []
var checkpoint_collected_coin_names = []
var collected_door_and_key_names = []
var checkpoint_collected_door_and_key_names = []
var coin_counter
var checked_checkpoint_name
var checkpoints
var player
var camera
var used_touchscreen = false
var play_time = 0.0

func _ready():
	SoundController.toggleMusic(true)
	RenderingServer.set_default_clear_color(Color("eeb67e"))
	$"../Level/UI".showTouchBtns()

func _process(delta):
	play_time += delta
	$"../Level/UI/TopPanel/Label_play_time".text = convertPlayTime(play_time)

func stopPlayTime():
	set_process(false)

func convertPlayTime(time):
	var minutes = int(time / 60)
	var seconds = str(fmod(time, 60)).pad_zeros(2).pad_decimals(2)
	if minutes > 0: return str(minutes) + ":" + seconds
	return seconds

func addCoin(coin_name):
	collected_coin_names.append(coin_name)
	coin_counter.refresh()

func restoreCoins():
	collected_coin_names = [] + checkpoint_collected_coin_names
	
	for i in $"../Level/Coin".get_children():
		if i.name in collected_coin_names: i.queue_free()
	
	coin_counter.refresh()

func restoreDoorAndKeys():
	collected_door_and_key_names = [] + checkpoint_collected_door_and_key_names

	for i in $"../Level/DoorAndKey".get_children():
		if i.name in collected_door_and_key_names: i.queue_free()

func checkpoint():
	checkpoints = $"../Level/Checkpoint".get_children()
	player = $"../Level/Player"
	
	for i in checkpoints:
		if i.name == checked_checkpoint_name:
			i.check()
			player.position = i.position - Vector2(0, 72)
			break
	
	player.visible = true
	
	restoreCoins()
	restoreDoorAndKeys()
