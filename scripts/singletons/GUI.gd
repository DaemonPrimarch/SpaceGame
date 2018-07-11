extends CanvasLayer

onready var HP_bar_helper = $HP_bar_helper

func set_room_name(name):
	get_node("room_label").text = name