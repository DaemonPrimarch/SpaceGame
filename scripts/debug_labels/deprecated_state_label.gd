extends "res://addons/state_labels/debug_label.gd"

func _process(delta):
	text = get_parent().get_state()