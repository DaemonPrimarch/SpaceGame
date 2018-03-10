extends "res://scripts/debug_label.gd"

func _process(delta):
	if(get_parent().is_on_platform()):
		text = "ON_PLATFORM"
	else:
		text = ""
