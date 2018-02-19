extends Node

var loaded_rooms = {}

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
	
	print("Loaded: ", packed.get_path())
	
	return loaded_room
	
func get_room_of_node(node):
	var current_room = node
	
	while(not is_room_loaded(current_room)):
		current_room = current_room.get_parent()
		
		if(current_room.is_in_group("room") and not is_room_loaded(current_room)):
			add_room_as_loaded(current_room)
		
	return current_room

func unload_room(room):
	print("Unloaded: ", room.get_path())
	
	remove_room_as_loaded(room)
	
	get_tree().get_root().remove_child(room)

func warp_node_to_room(node, room, arrival_pos_id):
	var old_room = get_room_of_node(node)
	
	node.get_parent().remove_child(node)
	
	var old_pos = old_pos.get_position()
	
	unload_room(old_room)
	
	var loaded_room
	
	if(typeof(room) == TYPE_STRING):
		loaded_room = load_room(room, old_pos + Vector2(10000, 10000))
	else:
		loaded_room = load_packed_room(room, old_pos + Vector2(10000, 10000))
		
	var arrivals = get_tree().get_nodes_in_group("warp_arrival")
	var arrival_pos = Vector2(0,0)
	
	if(arrival_pos_id != null and arrival_pos_id != ""):
		for arrival in arrivals:
			if(arrival.get_arrival_ID() == arrival_pos_id):
				arrival_pos = (arrival.get_global_position())
				arrival_pos = loaded_room.to_local(arrival_pos)
	
	node.set_position(arrival_pos)
	loaded_room.add_child(node)
	
	node.emit_signal("room_entered")
	loaded_room.emit_signal("player_entered", node)
	
	#loaded_room.set_position(Vector2(0,0))
	
	