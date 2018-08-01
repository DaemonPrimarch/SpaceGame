tool
extends Area2D

signal AABB_changed()

func _ready():
	add_to_group("extended_area_2D")
	
	for node in get_children():
		if(node.has_method("get_AABB")):
			node.connect("AABB_changed", self, "emit_signal", ["AABB_changed"])

func get_AABB():
	var box = Rect2()
	
	for node in get_children():
		if(node.has_method("get_AABB")):
			if(box.has_no_area()):
				box = node.get_AABB()
			else:
				box.merge(node.get_AABB())
	
	return box