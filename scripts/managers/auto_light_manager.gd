tool
extends Node

func _ready():
	get_tree().connect("node_added", self, "_on_node_added")
	get_parent().connect("room_lit", self, "_on_room_darkness_changed")
	get_parent().connect("room_darkened", self, "_on_room_darkness_changed")

func _on_room_darkness_changed():
	if(is_inside_tree()):
		for light in get_tree().get_nodes_in_group("auto_light"):
			if(light.enabled != get_parent().is_dark()):
				light.enabled = get_parent().is_dark()

func _on_node_added(node):
	if(node.is_in_group("auto_light")):
		if(node.enabled != get_parent().is_dark()):
			node.enabled = get_parent().is_dark()

func _exit_tree():
	get_tree().connect("node_added", self, "_on_node_added")