extends Node

var active_camera = null

func get_active_camera():
	return active_camera

func set_active_camera(camera):
	if(get_active_camera() != null):
		get_active_camera().set_active(false)
	
	active_camera = camera