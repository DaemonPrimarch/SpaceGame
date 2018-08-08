tool
extends Area2D

func _ready():
	set_physics_process(not Engine.editor_hint)
	
	connect("body_entered", self, "entered")
	connect("body_exited", self, "exited")
	
func entered(thing):
	if(thing.is_in_group("carries_camera")):
		add_camera_limit_rect(thing, get_area())

func exited(thing):
	if(thing.is_in_group("carries_camera")):
		remove_camera_limit_rect(thing, get_area())

func get_area():
	return get_parent()
	
func add_camera_limit_rect(body, rect):
	for child in body.get_children():
		if(child.is_in_group("extended_camera")):
			child.add_limit_area(rect)

func remove_camera_limit_rect(body, rect):
	for child in body.get_children():
		if(child.is_in_group("extended_camera")):
			child.remove_limit_area(rect)