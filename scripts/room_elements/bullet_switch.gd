tool

extends "res://scripts/room_elements/switch.gd"

export var toggleable = false
var toggled = false

func is_toggleable():
	return toggleable

func _on_bullet_hit(bullet):
	if(is_toggleable()):
		toggle()
	else:
		if(not toggled):
			switch_on()
			toggled = true