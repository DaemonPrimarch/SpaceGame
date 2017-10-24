extends "res://scripts/better_KinematicBody2D"

signal switch_on
signal switch_off

export var on = false setget set_on, is_on

export var togglable = false

func on_bullet_hit(bullet):
	if(togglable):
		set_on(not is_on())
	else:
		set_on(true)
	
func is_on():
	return on
	
func set_on(value):
	on = value
	if(value):
		emit_signal("switch_on")
	else:
		emit_signal("switch_off")
	