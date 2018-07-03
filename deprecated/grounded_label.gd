extends "res://addons/state_labels/debug_label.gd"

func _physics_process(delta):
	if(get_parent().is_grounded()):
		text = "GROUNDED"
	else:
		text = ""
