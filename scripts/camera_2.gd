extends Node2D

export var active = true

var default_pos = Vector2()

var original_size = Vector2()

export var zoom = 1.0 setget set_zoom, get_zoom

export var stay_within_terrain = true

signal completed_zoom
signal entered_container

var container = null

func is_in_container():
	return container != null
	
func set_container(cont):
	container = cont
	
	set_zoom(1)
	
func get_container():
	return container

func get_follow_point():
	return get_parent().global_position

func _ready():
	default_pos = position

func set_zoom(new_zoom):	
	call_deferred("scale_viewport", (Vector2(new_zoom/get_zoom(), new_zoom/get_zoom())))

	zoom = new_zoom

func zoom_to(zoom, time):
	print("ZOOMING TO:  ", zoom)
	get_node("zoom_to").stop_all()
	get_node("zoom_to").interpolate_method (self, "set_zoom", get_zoom(), zoom, time, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 0 )
	get_node("zoom_to").start()
	
func scale_viewport(scale):
	if(is_inside_tree()):
		var pos = get_viewport().canvas_transform.origin
		get_viewport().canvas_transform.origin = Vector2()
		get_viewport().canvas_transform = get_viewport().canvas_transform.scaled(scale)
		get_viewport().canvas_transform.origin = pos
	else:
		print("NOT IN TREE")

func get_zoom():
	return zoom

func _exit_tree():
	set_container(null)

func _physics_process(delta):
#	if(Input.is_action_pressed("play_up")):
#		position += Vector2(0, -64 * 2) * delta
#	if(Input.is_action_pressed("play_down")):
#		position += Vector2(0, 64 * 2) * delta
#	if(Input.is_action_pressed("play_left")):
#		position += Vector2(-64 * 2, 0) * delta
#	if(Input.is_action_pressed("play_right")):
#		position += Vector2(64 * 2, 0) * delta

	if(active):
		var dir = Vector2()
			
		if((default_pos - position).length() <= 64):
			dir = default_pos - position
		else:
			dir = (default_pos - position).normalized() * 64
		
		get_node("debug/default_pos").position = -position + default_pos
			
		get_node("debug/RayCast2D").cast_to = dir
			
		position += dir
			
		get_node("debug/Sprite").modulate = Color(255, 0, 0)
		get_node("debug/tr").modulate = Color(255, 0, 0)
		get_node("debug/br").modulate = Color(255, 0, 0)
		get_node("debug/tl").modulate = Color(255, 0, 0)
		get_node("debug/bl").modulate = Color(255, 0, 0)
			
		var bottom_right = get_viewport().size/2 / PHYSICS_HELPER.get_global_scale_of_node(self) / zoom
		var bottom_left = get_viewport().size/2 * Vector2(-1, 1) / PHYSICS_HELPER.get_global_scale_of_node(self) / zoom
		var top_right = get_viewport().size/2 * Vector2(1, -1) / PHYSICS_HELPER.get_global_scale_of_node(self) / zoom
		var top_left = get_viewport().size/2 * -1 / PHYSICS_HELPER.get_global_scale_of_node(self) / zoom
			
		get_node("debug/tr").position = top_right
		get_node("debug/br").position = bottom_right
		get_node("debug/tl").position = top_left
		get_node("debug/bl").position = bottom_left	
		
		if(stay_within_terrain and is_in_container()):
			var offset = Vector2()
				
			var polygon  = get_container().get_global_polygon()
				
			if(MATHS.is_point_in_polygon(get_parent().global_position, polygon)):
				get_node("debug/Sprite").modulate = Color(0, 255, 0)
				if(not MATHS.is_point_in_polygon(to_global(top_left), polygon)):
					get_node("debug/tl").modulate = Color(0, 255, 0)
					
					var new_offset = MATHS.offset_point_polygon(to_global(top_left), polygon)
					
					if(abs(offset.x) < abs(new_offset.x)):
						offset.x = new_offset.x
					if(abs(offset.y) < abs(new_offset.y)):
						offset.y = new_offset.y
				if(not MATHS.is_point_in_polygon(to_global(top_right), polygon)):
					get_node("debug/tr").modulate = Color(0, 255, 0)
					
					var new_offset = MATHS.offset_point_polygon(to_global(top_right), polygon)
					
					if(abs(offset.x) < abs(new_offset.x)):
						offset.x = new_offset.x
					if(abs(offset.y) < abs(new_offset.y)):
						offset.y = new_offset.y
				if(not MATHS.is_point_in_polygon(to_global(bottom_left), polygon)):
					get_node("debug/bl").modulate = Color(0, 255, 0)
					
					var new_offset = MATHS.offset_point_polygon(to_global(bottom_left), polygon)
					
					if(abs(offset.x) < abs(new_offset.x)):
						offset.x = new_offset.x
					if(abs(offset.y) < abs(new_offset.y)):
						offset.y = new_offset.y
				if(not MATHS.is_point_in_polygon(to_global(bottom_right),polygon)):
					get_node("debug/br").modulate = Color(0, 255, 0)
					var new_offset = MATHS.offset_point_polygon(to_global(bottom_right), polygon)
					
					if(abs(offset.x) < abs(new_offset.x)):
						offset.x = new_offset.x
					if(abs(offset.y) < abs(new_offset.y)):
						offset.y = new_offset.y	
				position -= offset
					
		get_viewport().canvas_transform.origin = ((-global_position - position + position * PHYSICS_HELPER.get_global_scale_of_node(self))  * get_viewport().canvas_transform.get_scale()) + get_viewport_rect().size/2
		
