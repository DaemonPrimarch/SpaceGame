extends "res://scripts/switch.gd"

export var togglable = false

func on_bullet_hit(bullet):
	if(togglable):
		toggle()
	else:
		set_on(true)
