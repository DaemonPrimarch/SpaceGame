extends "res://addons/state_labels/debug_label.gd"

export (NodePath) var node_path
export var tracked_value = ""
export var tracked_function = ""

func _physics_process(delta):
	if(tracked_value != ""):
		text = str(get_node(node_path)[tracked_value])
	elif(tracked_function != ""):
		text = str(get_node(node_path).call(tracked_function))