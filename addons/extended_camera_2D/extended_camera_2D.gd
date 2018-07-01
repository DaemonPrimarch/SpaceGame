tool
extends Camera2D

#https://github.com/markopolojorgensen/godot_2d_camera_limiter/blob/master/addons/camera_limiter/focus_limiter.gd

var limit_area = null

func _ready():
	add_to_group("camera")
	add_to_group("extended_camera")
	
	if(not Engine.editor_hint):
		for name in ["tween_top", "tween_bottom", "tween_left", "tween_right"]:
			var tween = Tween.new()
			tween.set_name(name)
			add_child(tween)
	
	if(get_parent() is KinematicBody2D):
		get_parent().add_to_group("carries_camera")
		
func set_limit_area(area):
	if(area != limit_area):
		if(not area is null):
			pass
		
		limit_area = area
