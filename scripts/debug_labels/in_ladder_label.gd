extends "res://scripts/debug_label.gd"

func _process(delta):
	if(get_parent().is_inside_ladder()):
		text =  "IN LADDER"
	else:
		text = ""
