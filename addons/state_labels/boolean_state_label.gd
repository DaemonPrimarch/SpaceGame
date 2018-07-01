extends "res://addons/state_labels/debug_label.gd"

export(NodePath) var node_path

export var tracked_value = ""

export var true_value = ""
export var false_value = ""

func _physics_process(delta):
	if(get_node(node_path)[tracked_value]):
		text = true_value
	else:
		text = false_value