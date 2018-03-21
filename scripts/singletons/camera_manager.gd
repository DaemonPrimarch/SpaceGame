extends Node

var active_camera = null

func get_active_camera():
	return active_camera

func set_active_camera(camera):
	var prev_active_camera = active_camera
	
	active_camera = camera
	
	if(prev_active_camera != null):
		prev_active_camera.set_active(false)