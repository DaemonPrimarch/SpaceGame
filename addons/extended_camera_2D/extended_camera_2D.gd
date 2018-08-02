tool
extends Camera2D

export var debug_drawing = false

#https://github.com/markopolojorgensen/godot_2d_camera_limiter/blob/master/addons/camera_limiter/focus_limiter.gd

func _ready():
	add_to_group("camera")
	add_to_group("extended_camera")
	add_to_group("no_flip")
	
	if(not Engine.editor_hint):
		for name in ["tween_top", "tween_bottom", "tween_left", "tween_right", "tween_zoom", "tween_offset", "tween_position"]:
			var tween = Tween.new()
			tween.set_name(name)
			tween.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
			add_child(tween)
	
	if(get_parent() is KinematicBody2D):
		get_parent().add_to_group("carries_camera")
		
func zoom_to(new_zoom, time):
	if(time > 0):
		get_node("tween_zoom").stop_all()
		get_node("tween_zoom").interpolate_property(self, "zoom", zoom, new_zoom, time, Tween.TRANS_LINEAR, null)
		get_node("tween_zoom").start()
	else:
		zoom = new_zoom

func move_to(pos, time = 0, emmidiate = false):
	if(emmidiate):
		global_position = get_camera_screen_center()

	if(time > 0):
		get_node("tween_position").stop_all()
		get_node("tween_position").interpolate_property(self, "position", position, pos, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		get_node("tween_position").start()
	else:
		position = pos

func move_at_speed_to(pos, speed, emmidiate = false):
	move_to(pos, (position - pos).length()/speed,  emmidiate)

func move_offset_to(pos, time, emmidiate = false):
	if(time > 0):
		get_node("tween_offset").interpolate_method(self, "set_offset", offset, pos, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		get_node("tween_offset").start()
	else:
		offset = pos

func set_offset(offset):
	.set_offset(offset)
	
	update()

func move_offset_at_speed(pos, speed, emmidiate = false):
	move_offset_to(pos, (position - pos).length()/speed, emmidiate)

func _physics_process(delta):
	pass
func get_stupid_rect():
	return Rect2(get_camera_screen_center() - get_viewport_rect().size/2 * Vector2(1,1), get_viewport().size)
		
func _draw():
	if(debug_drawing):
	#draw_rect(Rect2(offset - Vector2(5, 5), Vector2(10,10)), Color(1,1,0), false)
		
		#print((to_global(get_camera_screen_center())))
		
		draw_rect(Rect2(get_camera_screen_center() - global_position + Vector2(5, 5), Vector2(10,10)), Color(1,1,0), true)
		
		draw_rect(Rect2(Vector2(10, 10), Vector2(20,20)), Color(1,0,1), false)

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
	
	force_update_scroll()
	
func remove_limit_area(area):
	var i = limit_areas.find(area)
	
	limit_areas.remove(i)
	
	if(i == 0):
		update_limit_area()

func add_limit_area(area):
	limit_areas.push_front(area)

	update_limit_area()