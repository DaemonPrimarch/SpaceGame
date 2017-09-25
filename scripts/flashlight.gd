extends "res://scripts/weapon.gd"

func _ready():
	pass

func press_trigger():
	if(get_node("light").is_enabled()):
		get_node("light").set_enabled(false)
	else:
		get_node("light").set_enabled(true)