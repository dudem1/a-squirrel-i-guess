extends Control

func _ready():
	Global.coin_counter = self
	refresh()

func refresh():
	$Label.text = str(Global.collected_coin_names.size())
