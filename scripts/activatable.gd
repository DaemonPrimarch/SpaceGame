tool

extends Node

signal activated
signal deactivated

export var active = true setget set_active, is_active

func set_active(val):
	if(is_active() != val):
		active = val
		
		if(val):
			emit_signal("activated")
		else:
			emit_signal("deactivated")