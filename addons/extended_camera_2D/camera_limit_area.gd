tool
extends Area2D.

export var simple = true setget set_simple
export var can_zoom_out = false
export(NodePath) var custom_container

func _ready():
	connect("body_entered", self, "entered")
	connect("body_exited", self, "exited")
	
func entered(thing):
	if(thing.is_in_group("carries_camera")):
		for child in thing.get_children():
			if(child.is_in_group("extended_camera")):
				child.add_limit_area(self)

func exited(thing):
	if(thing.is_in_group("carries_camera")):
		for child in thing.get_children():
			if(child.is_in_group("extended_camera")):
				child.remove_limit_area(self)
					
func set_simple(val):
	simple = val

func is_simple():
	return simple

func get_AABB():
	var box = Rect2()
	for child in get_children():
		if(child is load("res://addons/extended_collision_polygon_2D/extended_collision_polygon_2D.gd")):
			if(not box.has_no_area()):
				box = box.merge(child.get_AABB())
			else:
				box = child.get_AABB()
	
	return box
	
func get_limit_rect():
	if(is_simple()):
		return get_AABB()
	else:
		var box = get_node("/root/MATHS").get_AABB_of_polygon(get_node(custom_container).polygon)
		
		box.position += get_node(custom_container).global_position
		
		return box