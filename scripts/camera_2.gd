extends Node2D

export var active = true

var offset = Vector2()

var original_size = Vector2()

export var zoom = 1.0 setget set_zoom, get_zoom

export var stay_within_terrain = true

export var debug_controls = false

export var debug_labels = true

signal completed_zoom
signal entered_container

var container = null

enum {FOLLOW_PARENT, DIRECT_CONTROL}

export var mode = FOLLOW_PARENT

func is_active():
	return active
	
func get_control_mode():
	return mode

func debug_controls_enabled():
	return debug_controls

func debug_labels_enabled():
	return debug_labels

func set_control_mode(m):
	mode = m

func set_offset(position):
	offset = position

func get_offset():
	return offset

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
	set_offset(position)

func set_zoom(new_zoom):	
	call_deferred("scale_viewport", (Vector2(new_zoom/get_zoom(), new_zoom/get_zoom())))

	zoom = new_zoom

func zoom_to(zoom, time):
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
	
func move_offset_to(to, time):
	get_node("offset_move").stop_all()
	get_node("offset_move").interpolate_method (self, "set_offset", get_offset(), to, time, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 0 )
	get_node("offset_move").start()

func _physics_process(delta):
	if(is_active()):
		
		get_node("debug").visible = debug_labels_enabled()
		
		var bottom_right = get_viewport().size/2 / PHYSICS_HELPER.get_global_scale_of_node(self) / zoom
		var bottom_left = get_viewport().size/2 * Vector2(-1, 1) / PHYSICS_HELPER.get_global_scale_of_node(self) / zoom
		var top_right = get_viewport().size/2 * Vector2(1, -1) / PHYSICS_HELPER.get_global_scale_of_node(self) / zoom
		var top_left = get_viewport().size/2 * -1 / PHYSICS_HELPER.get_global_scale_of_node(self) / zoom
		
		if(debug_labels_enabled()):	
			get_node("debug/Sprite").modulate = Color(255, 0, 0)
			get_node("debug/tr").modulate = Color(255, 0, 0)
			get_node("debug/br").modulate = Color(255, 0, 0)
			get_node("debug/tl").modulate = Color(255, 0, 0)
			get_node("debug/bl").modulate = Color(255, 0, 0)
			
			get_node("debug/tr").position = top_right
			get_node("debug/br").position = bottom_right
			get_node("debug/tl").position = top_left
			get_node("debug/bl").position = bottom_left	
		
		if(get_control_mode() == FOLLOW_PARENT):
			var dir = Vector2()
				
			if((get_offset() - position).length() <= 64):
				dir = get_offset() - position
			else:
				dir = (get_offset() - position).normalized() * 64
			
			if(debug_labels_enabled()):
				get_node("debug/default_pos").position = -position + get_offset()
					
				get_node("debug/RayCast2D").cast_to = dir
				
			position += dir
		elif(get_control_mode() == DIRECT_CONTROL):
			if(debug_controls_enabled()):
				var speed = 64 * 4
				
				if(Input.is_action_pressed("play_up")):
					position += Vector2(0, -speed) * delta
				if(Input.is_action_pressed("play_down")):
					position += Vector2(0, speed) * delta
				if(Input.is_action_pressed("play_left")):
					position += Vector2(-speed, 0) * delta
				if(Input.is_action_pressed("play_right")):
					position += Vector2(speed, 0) * delta
		
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
		
