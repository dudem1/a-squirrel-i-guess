extends Node

const born = preload("res://assets/sounds/born.wav")
const coin = preload("res://assets/sounds/coin.wav")
const hurt = preload("res://assets/sounds/hurt.wav")
const jump = preload("res://assets/sounds/jump.wav")
const key = preload("res://assets/sounds/key.wav")
const checkpoint = preload("res://assets/sounds/checkpoint.wav")
const firework = preload("res://assets/sounds/firework.wav")

@onready var audio_players_fx = $AudioStreamPlayer_fx

func isMusicPlaying():
	return $Music.playing

func toggleMusic(value = !$AudioStreamPlayer_music.playing):
	$AudioStreamPlayer_music.playing = value

func playSound(sound, pitch_scale:float = 1):
	for audio_player in audio_players_fx.get_children():
		if not audio_player.playing:
			audio_player.stream = sound
			audio_player.pitch_scale = pitch_scale
			audio_player.play()
			break
