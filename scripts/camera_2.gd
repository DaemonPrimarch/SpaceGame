extends Node2D

export var active = true

var default_pos = Vector2()

var original_size = Vector2()

export var zoom = 1.0 setget set_zoom, get_zoom

export var stay_within_terrain = true

func _ready():
	#set_zoom(get_zoom())
	default_pos = position
	
	#print(get_viewport().canvas_transform.get_scale())
	
	get_parent().connect("room_entered", self, "on_room_enter")

func on_room_enter():
	
	if(get_node("/root/ROOM_MANAGER").get_room_of_node(self).has_default_camera_position()):
		default_pos = get_node("/root/ROOM_MANAGER").get_room_of_node(self).get_default_camera_position()

func set_zoom(new_zoom):
	#print(Vector2(new_zoom/get_zoom(), new_zoom/get_zoom()))
		
	call_deferred("scale_viewport", (Vector2(new_zoom/get_zoom(), new_zoom/get_zoom())))
	
		
	zoom = new_zoom
	
func scale_viewport(scale):
#	print("scale", scale)
#	get_viewport().set_size_override (true)
	var pos = get_viewport().canvas_transform.origin
	get_viewport().canvas_transform.origin = Vector2()
	get_viewport().canvas_transform = get_viewport().canvas_transform.scaled(scale)
	get_viewport().canvas_transform.origin = pos
#	print(get_viewport().size)
#	get_viewport().size *= scale
#	print(get_viewport().size)
	pass
func get_zoom():
	return zoom

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
		if(stay_within_terrain):
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
			
			for pol in get_tree().get_nodes_in_group("camera_container"):
				
				
				var offset = Vector2()
				
				var polygon  = []
				
				for p in pol.polygon:
					polygon.push_back(p + pol.global_position)
				
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
					
		get_viewport().canvas_transform.origin = (-global_position  * get_viewport().canvas_transform.get_scale()) + get_viewport_rect().size/2
