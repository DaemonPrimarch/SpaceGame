tool
extends Node2D

signal open
signal close

export(bool) var open setget set_open, is_open

var opened = false

func _ready():
	set_open(open)

func is_open():
	return opened
	
func set_open(value):
	if(value):
		emit_signal("open")
	else:
		emit_signal("close")
			
	opened = value

func toggle_open():
	set_open(not is_open())