tool
extends Area2D.

export var simple = true

func _ready():
	connect("body_entered", self, "entered")
	connect("body_exited", self, "exited")
	
func entered(thing):
	if(thing.is_in_group("carries_camera")):
		for child in thing.get_children():
			if(child.is_in_group("extended_camera")):
				child.set_limit_area(self)

func exited(thing):
	if(thing.is_in_group("carries_camera")):
		for child in thing.get_children():
			if(child.is_in_group("extended_camera")):
				if(child.get_limit_area() == self):
					child.set_limit_area(null)

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
	
	box.position += global_position
	
	return box