extends "res://addons/state_labels/debug_label.gd"

func _process(delta):
	if(get_parent().is_on_platform()):
		text = "ON_PLATFORM"
	else:
		text = ""
