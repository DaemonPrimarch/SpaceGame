extends Node

export var active = false setget set_active

func set_active(val):
	active = val
	
	if(is_inside_tree()):
		set_physics_process(val)

func is_active():
	return active

func _ready():
	set_active(is_active())
