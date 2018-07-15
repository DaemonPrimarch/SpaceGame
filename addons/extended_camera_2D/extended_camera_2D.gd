tool
extends Camera2D

#https://github.com/markopolojorgensen/godot_2d_camera_limiter/blob/master/addons/camera_limiter/focus_limiter.gd

func _ready():
	add_to_group("camera")
	add_to_group("extended_camera")
	
	if(not Engine.editor_hint):
		for name in ["tween_top", "tween_bottom", "tween_left", "tween_right", "tween_zoom", "tween_offset"]:
			var tween = Tween.new()
			tween.set_name(name)
			add_child(tween)
	
	if(get_parent() is KinematicBody2D):
		get_parent().add_to_group("carries_camera")
		
func zoom_to(new_zoom, time):
	if(time > 0):
		get_node("tween_zoom").interpolate_property(self, "zoom", zoom, new_zoom, time, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		get_node("tween_zoom").start()
	else:
		zoom = new_zoom

func move_offset_to(pos, time):
	if(time > 0):
		get_node("tween_offset").interpolate_property(self, "offset", offset, pos, time, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		get_node("tween_offset").start()
	else:
		offset = pos

func _physics_process(delta):
	pass
	
func get_stupid_rect():
	return Rect2(get_camera_screen_center() - get_viewport_rect().size/2 * Vector2(1,1), get_viewport().size)
		
func _draw():
	pass

var limit_areas = []

func has_limit_area():
	return not limit_areas.empty()

func get_limit_area():
	return limit_areas[0]

func update_limit_area():
	if(has_limit_area()):
		var aabb = get_limit_area().get_limit_rect()

		limit_left = aabb.position.x
		limit_right = aabb.end.x
		limit_top = aabb.position.y
		limit_bottom = aabb.end.y
	else:
		limit_left = -10000000
		limit_right = 10000000
		limit_top = -10000000
		limit_bottom = 10000000

func remove_limit_area(area):
	var i = limit_areas.find(area)
	
	limit_areas.remove(i)
	
	if(i == 0):
		update_limit_area()

func add_limit_area(area):
	limit_areas.push_front(area)

	update_limit_area()