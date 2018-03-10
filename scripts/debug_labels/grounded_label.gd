extends "res://scripts/debug_label.gd"

func _process(delta):
	if(get_parent().is_grounded()):
		text = "GROUNDED"
	else:
		text = "NOT GROUNDED"
