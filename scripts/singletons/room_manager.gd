extends Node

var loaded_rooms = {}

var done = 0

signal PHYS

func add_room_as_loaded(room):
	loaded_rooms[room.get_path()] = room
	
func remove_room_as_loaded(room):
	loaded_rooms.erase(room)
	
func is_room_loaded(path):
	return loaded_rooms.has(path.get_path())

func load_room(path, pos):
	return load_packed_room(load(path), pos)

func load_packed_room(packed, pos):
	var loaded_room = packed.instance()
	
	loaded_room.set_position(pos)
	
	get_tree().get_root().add_child(loaded_room)
	
	add_room_as_loaded(loaded_room)
	
	return loaded_room
	
func get_room_of_node(node):
	var current_room = node
	
	while(not is_room_loaded(current_room)):
		current_room = current_room.get_parent()
		
		if(current_room.is_in_group("room") and not is_room_loaded(current_room)):
			add_room_as_loaded(current_room)
		
	return current_room

func unload_room(room):
	remove_room_as_loaded(room)
	
	room.queue_free()

func warp_node_to_room(node, room, arrival_pos_id):
	if(done <= 10000):
		var old_room = get_room_of_node(node)
		
		node.get_parent().remove_child(node)
		
		var old_pos = old_room.position
		
		old_room.position += Vector2(5000, 5000)
		
		if(old_room.has_node("CanvasModulate")):
			old_room.get_node("CanvasModulate").visible = false
		
		unload_room(old_room)
		
		var loaded_room
		
		var new_pos = Vector2()
		
		if(old_pos.length() <= 30000):
			new_pos = old_pos + Vector2(10000, 10000)
		
		if(typeof(room) == TYPE_STRING):
			loaded_room = load_room(room, new_pos)
		else:
			loaded_room = load_packed_room(room, new_pos)
			
		var arrivals = get_tree().get_nodes_in_group("warp_arrival")
		var arrival_pos = Vector2(0,0)
		
		if(arrival_pos_id != null and arrival_pos_id != ""):
			for arrival in arrivals:
				if(arrival.get_arrival_ID() == arrival_pos_id and get_room_of_node(arrival) == loaded_room):
					arrival_pos = (arrival.get_global_position())
					arrival_pos = loaded_room.to_local(arrival_pos)

		yield(self, "PHYS")

		node.set_position(arrival_pos)
		loaded_room.add_child(node)
		
		node.emit_signal("room_entered")
		loaded_room.emit_signal("player_entered", node)
		done += 1
	
	#loaded_room.set_position(Vector2(0,0))

func _physics_process(delta):
	emit_signal("PHYS")
	