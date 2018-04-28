extends "res://scripts/debug_label.gd"

export (NodePath) var node_path
export var tracked_value = ""

func _physics_process(delta):
	text = str(get_node(node_path)[tracked_value])