tool
extends Camera2D

#https://github.com/markopolojorgensen/godot_2d_camera_limiter/blob/master/addons/camera_limiter/focus_limiter.gd

var limit_area = null

func _ready():
	add_to_group("camera")
	add_to_group("extended_camera")
	
	if(not Engine.editor_hint):
		for name in ["tween_top", "tween_bottom", "tween_left", "tween_right", "tween_zoom"]:
			var tween = Tween.new()
			tween.set_name(name)
			add_child(tween)
	
	if(get_parent() is KinematicBody2D):
		get_parent().add_to_group("carries_camera")
func zoom_to(new_zoom, time):
	pass
func set_limit_area(area):
	if(area != limit_area):
		if(not area == null):
			if(area.is_simple()):
				var aabb = area.get_AABB()
				
				limit_left = aabb.position.x
				limit_right = aabb.end.x
				limit_top = aabb.position.y - aabb.size.y
				limit_bottom = aabb.position.y
				
				print(aabb)
		else:
			limit_left = -10000000
			limit_right = 10000000
			limit_top = -10000000
			limit_bottom = 10000000
		limit_area = area
		
func get_limit_area():
	return limit_area