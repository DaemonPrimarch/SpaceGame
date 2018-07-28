extends "res://addons/state_labels/debug_label.gd"

export(NodePath) var node_path

export var tracked_value = ""
export var tracked_function = ""

export var true_value = ""
export var false_value = ""

func _physics_process(delta):
	if(has_node(node_path)):
		var val = false
		
		if(tracked_value != ""):
			val = get_node(node_path)[tracked_value]
		elif(tracked_function != ""):
			val = (get_node(node_path).call(tracked_function))
			
		if(val):
			text = true_value
		else:
			text = false_value
	else:
		print("HAS NO NODE WITH PATH: ", node_path)