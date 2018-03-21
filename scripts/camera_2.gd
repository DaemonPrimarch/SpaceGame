extends Node2D

export var active = true setget set_active, is_active

var offset = Vector2()

var original_size = Vector2()
export var velocity = Vector2(64, 64) 

export var zoom = 1.0 setget set_zoom, get_zoom

export var stay_within_terrain = true

export var debug_controls = false

export var debug_labels = true

signal completed_zoom
signal entered_container

var container = null

var temp_containers = []

var fixed_position = Vector2()

enum {FOLLOW_PARENT, DIRECT_CONTROL}

export var mode = FOLLOW_PARENT

func is_active():
	return active

func set_active(val):
	active = val
	
	if(is_inside_tree()):
		if(not active and get_node("/root/CAMERA_MANAGER").get_active_camera() == self):	
			get_node("/root/CAMERA_MANAGER").set_active_camera(null)
		elif(active):
			get_node("/root/CAMERA_MANAGER").set_active_camera(self)
	
func get_control_mode():
	return mode

func debug_controls_enabled():
	return debug_controls

func debug_labels_enabled():
	return debug_labels

func set_control_mode(m):
	mode = m
	
	if(mode == DIRECT_CONTROL):
		fixed_position = get_parent().global_position

func set_offset(position):
	offset = position

func get_offset():
	return offset

func is_in_container():
	return container != null
	
func set_container(cont):
	var old_cont = container
	
	container = cont
	
	if(cont):
		set_zoom(cont.get_default_camera_zoom())
		if(cont.has_default_camera_offset()):
			move_offset_to(cont.get_default_camera_offset(), 0.2)
		if(old_cont):
			var bottom_right = get_viewport().size/2  / zoom
			var bottom_left = get_viewport().size/2 * Vector2(-1, 1) / zoom
			var top_right = get_viewport().size/2 * Vector2(1, -1)  / zoom
			var top_left = get_viewport().size/2 * -1 / zoom

			position -= MATHS.offset_rect_polygon(Rect2(to_global(top_left), bottom_right - top_left), old_cont.get_global_polygon())

			set_control_mode(DIRECT_CONTROL)
		
			move_to(position - MATHS.offset_rect_polygon(Rect2(to_global(top_left), bottom_right - top_left), cont.get_global_polygon()), 0.5)
	
func _on_camer_transfer_timer_timeout():
	temp_containers = []
	moving = false
	
	set_control_mode(FOLLOW_PARENT)
	
func get_container():
	return container

func get_follow_point():
	return get_parent().global_position

func set_stay_within_terrain(val):
	stay_within_terrain = val
	
func is_staying_within_terrain():
	return stay_within_terrain

func _ready():
	print("READY")
	
	set_offset(position)
	
	set_active(is_active())
	
	if(get_parent().has_method("set_camera")):
		get_parent().set_camera(self)

func set_zoom(new_zoom):
	
	var zum = get_zoom()
	
	if(zum == null):
		zum = 1
	
	call_deferred("scale_viewport",(Vector2(new_zoom/zum, new_zoom/zum)))

	zoom = new_zoom

func zoom_to(zoom, time):
	get_node("zoom_to").stop_all()
	get_node("zoom_to").interpolate_method (self, "set_zoom", get_zoom(), zoom, time, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 0 )
	get_node("zoom_to").start()
	
func scale_viewport(scale):
	var pos = get_viewport().canvas_transform.origin
	get_viewport().canvas_transform.origin = Vector2()
	get_viewport().canvas_transform = get_viewport().canvas_transform.scaled(scale)
	get_viewport().canvas_transform.origin = pos

func get_zoom():
	return zoom

func _exit_tree():
	set_container(null)
	
func move_offset_to(to, time):
	get_node("offset_move").stop_all()
	get_node("offset_move").interpolate_method (self, "set_offset", get_offset(), to, time, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 0 )
	get_node("offset_move").start()

var moving = false
func move_to(pos, time):
	moving  = true
	get_node("camer_transfer_timer").start()
	
	get_node("move_to").stop_all()
	get_node("move_to").interpolate_property (self, "position", position, pos, time, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 0 )
	get_node("move_to").start()

func is_moving():
	return moving

func _physics_process(delta):
	if(is_active()):	
		get_node("debug").visible = debug_labels_enabled()
		
		if(debug_labels_enabled()):	
			get_node("debug/Sprite").modulate = Color(255, 0, 0)
			get_node("debug/tr").modulate = Color(255, 0, 0)
			get_node("debug/br").modulate = Color(255, 0, 0)
			get_node("debug/tl").modulate = Color(255, 0, 0)
			get_node("debug/bl").modulate = Color(255, 0, 0)
		
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
			if(debug_controls_enabled() and not true):
				var speed = 64 * 4
				
				if(Input.is_action_pressed("play_up")):
					position += Vector2(0, -speed) * delta
				if(Input.is_action_pressed("play_down")):
					position += Vector2(0, speed) * delta
				if(Input.is_action_pressed("play_left")):
					position += Vector2(-speed, 0) * delta
				if(Input.is_action_pressed("play_right")):
					position += Vector2(speed, 0) * delta
		
			position -= (get_parent().global_position - fixed_position)
		
		var bottom_right = get_viewport().size/2  / zoom
		var bottom_left = get_viewport().size/2 * Vector2(-1, 1) / zoom
		var top_right = get_viewport().size/2 * Vector2(1, -1)  / zoom
		var top_left = get_viewport().size/2 * -1 / zoom		
		get_node("debug/tr").position = top_right
		get_node("debug/br").position = bottom_right
		get_node("debug/tl").position = top_left
		get_node("debug/bl").position = bottom_left	
		if(is_staying_within_terrain() and is_in_container() and not is_moving()):
			position -= MATHS.offset_rect_polygon(Rect2(to_global(top_left) + (top_left + position) * (Vector2(1,1) - PHYSICS_HELPER.get_global_scale_of_node(self).abs()), bottom_right - top_left), get_container().get_global_polygon())
	
		get_viewport().canvas_transform.origin = ((-global_position - position * (Vector2(1,1) - PHYSICS_HELPER.get_global_scale_of_node(self).abs()))  * get_viewport().canvas_transform.get_scale()) + get_viewport_rect().size/2
