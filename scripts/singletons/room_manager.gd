extends Node

signal PHYS

var loaded_rooms = {}
var path_rooms = {}

var done = 0

func _ready():
	pass

func add_room_as_loaded(room, path):
	loaded_rooms[path] = room
	path_rooms[room] = path
	
	print("Loaded room: ", path)
	
func remove_room_as_loaded(room):
	loaded_rooms.erase(get_path_of_room(room))
	path_rooms.erase(room)
	
func is_room_loaded(path):
	return loaded_rooms.has(path)
	
func is_room_managed(room):
	return path_rooms.has(room)
	
func get_path_of_room(room):
	return path_rooms[room]

func load_room(path, pos):
	var loaded_room = load(path).instance()
	
	loaded_room.set_position(pos)
	
	if(loaded_room.has_node("player")):
		loaded_room.get_node("player").free()
	
	get_tree().get_root().add_child(loaded_room)
	
	add_room_as_loaded(loaded_room, path)
	
	return loaded_room	
	
func get_room_of_node(node):
	var current_room = node
	
	while(not is_room_managed(current_room)):
		current_room = current_room.get_parent()
		
		if(current_room.is_in_group("room") and not is_room_managed(current_room)):
			add_room_as_loaded(current_room, "INVALID")
		
	return current_room

func unload_room(room):
	for child in room.get_children():
		if(child is CanvasModulate):
			child.visible = false
	
	remove_room_as_loaded(room)
	
	room.queue_free()

func warp_node_to_room(node, room, arrival_pos_id):
	if(done <= 10000):
		var old_room = get_room_of_node(node)
		
		old_room.remove_child(node)
		
		var old_pos = old_room.position
		
		unload_room(old_room)
		
		var loaded_room
		
		var new_pos = Vector2()
		
		if(old_pos.length() <= 30000):
			new_pos = old_pos + Vector2(10000, 10000)
		
		loaded_room = load_room(room, new_pos)
			
		yield(self, "PHYS")


		var arrival_pos = Vector2(0,0)
		

		if(typeof(arrival_pos_id) == TYPE_STRING):
			var arrivals = get_tree().get_nodes_in_group("warp_arrival")
			
			if(arrival_pos_id != null and arrival_pos_id != ""):
				for arrival in arrivals:
					if(arrival.get_arrival_ID() == arrival_pos_id and get_room_of_node(arrival) == loaded_room):
						arrival_pos = (arrival.get_global_position())
						arrival_pos = loaded_room.to_local(arrival_pos)
			else:
				print("NEVER!")
	
			
			if(arrival_pos == Vector2(0,0)):
				print("ARRIVAL ID: ", arrival_pos_id)
				print("ARRIVAL POSITION NOT FOUND!")
		else:
			arrival_pos = arrival_pos_id

		
		if(loaded_room.has_node("player")):
			print("OLD PLAYER STILL PRESENT")
		
		node.set_position(arrival_pos)
		loaded_room.add_child(node)
		
		node.emit_signal("room_entered")
		loaded_room.emit_signal("player_entered", node)
		done += 1
	
	#loaded_room.set_position(Vector2(0,0))

func _physics_process(delta):
	emit_signal("PHYS")
	