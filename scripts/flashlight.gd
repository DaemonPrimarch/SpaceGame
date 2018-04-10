extends "res://scripts/weapon.gd"

func press_trigger():
	get_node("Light").enabled = not get_node("Light").enabled