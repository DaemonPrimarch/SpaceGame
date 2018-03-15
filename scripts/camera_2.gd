extends Node2D

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(delta):
#	if(Input.is_action_pressed("play_up")):
#		position += Vector2(0, -64 * 2) * delta
#	if(Input.is_action_pressed("play_down")):
#		position += Vector2(0, 64 * 2) * delta
#	if(Input.is_action_pressed("play_left")):
#		position += Vector2(-64 * 2, 0) * delta
#	if(Input.is_action_pressed("play_right")):
#		position += Vector2(64 * 2, 0) * delta

	position -= (position / 4)
	
	get_node("debug/Sprite").modulate = Color(255, 0, 0)
	get_node("debug/tr").modulate = Color(255, 0, 0)
	get_node("debug/br").modulate = Color(255, 0, 0)
	get_node("debug/tl").modulate = Color(255, 0, 0)
	get_node("debug/bl").modulate = Color(255, 0, 0)
	
	var bottom_right = get_viewport().size/2 /PHYSICS_HELPER.get_global_scale_of_node(self)
	var bottom_left = get_viewport().size/2 * Vector2(-1, 1) / PHYSICS_HELPER.get_global_scale_of_node(self)
	var top_right = get_viewport().size/2 * Vector2(1, -1) / PHYSICS_HELPER.get_global_scale_of_node(self)
	var top_left = get_viewport().size/2 * -1 / PHYSICS_HELPER.get_global_scale_of_node(self)
	
	get_node("debug/tr").position = top_right
	get_node("debug/br").position = bottom_right
	get_node("debug/tl").position = top_left
	get_node("debug/bl").position = bottom_left
	
	for pol in get_tree().get_nodes_in_group("camera_container"):
		
		
		var offset = Vector2()
		
		if(MATHS.is_point_in_polygon(get_parent().global_position, pol.polygon)):
			get_node("debug/Sprite").modulate = Color(0, 255, 0)
			if(not MATHS.is_point_in_polygon(to_global(top_left), pol.polygon)):
				get_node("debug/tl").modulate = Color(0, 255, 0)
				
				var new_offset = MATHS.offset_point_polygon(to_global(top_left), pol.polygon)
				
				if(abs(offset.x) < abs(new_offset.x)):
					offset.x = new_offset.x
				if(abs(offset.y) < abs(new_offset.y)):
					offset.y = new_offset.y
			if(not MATHS.is_point_in_polygon(to_global(top_right), pol.polygon)):
				get_node("debug/tr").modulate = Color(0, 255, 0)
				
				var new_offset = MATHS.offset_point_polygon(to_global(top_right), pol.polygon)
				
				if(abs(offset.x) < abs(new_offset.x)):
					offset.x = new_offset.x
				if(abs(offset.y) < abs(new_offset.y)):
					offset.y = new_offset.y
			if(not MATHS.is_point_in_polygon(to_global(bottom_left), pol.polygon)):
				get_node("debug/bl").modulate = Color(0, 255, 0)
				
				var new_offset = MATHS.offset_point_polygon(to_global(bottom_left), pol.polygon)
				
				if(abs(offset.x) < abs(new_offset.x)):
					offset.x = new_offset.x
				if(abs(offset.y) < abs(new_offset.y)):
					offset.y = new_offset.y
			if(not MATHS.is_point_in_polygon(to_global(bottom_right), pol.polygon)):
				get_node("debug/br").modulate = Color(0, 255, 0)
				var new_offset = MATHS.offset_point_polygon(to_global(bottom_right), pol.polygon)
				
				if(abs(offset.x) < abs(new_offset.x)):
					offset.x = new_offset.x
				if(abs(offset.y) < abs(new_offset.y)):
					offset.y = new_offset.y

			position -= offset
	get_viewport().canvas_transform.origin = -global_position + get_viewport_rect().size/2
