tool

extends "res://scripts/room_elements/switch.gd"

export var toggleable = false

func is_toggleable():
	return toggleable

func _on_bullet_hit(bullet):
	if(is_toggleable()):
		toggle()
	else:
		switch_on()