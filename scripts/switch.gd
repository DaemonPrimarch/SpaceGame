tool

extends Node2D

signal switch_on
signal switch_off

export(bool) var on setget set_on, is_on

var enabled = false

var first = true

func _ready():
	if(is_on()):
		emit_signal("switch_on")
	else:
		emit_signal("switch_off")
func set_on(value):
	if(value != enabled and is_inside_tree()):
		first = false
		if(value):
			emit_signal("switch_on")
		else:
			emit_signal("switch_off")
	enabled = value
	
func is_on():
	return enabled
	
func toggle():
	set_on(not is_on())