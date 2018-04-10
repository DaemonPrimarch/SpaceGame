tool
extends EditorPlugin

#var starting_room = "res://rooms/from_bridge/room_3.tscn"
var starting_room = "res://rooms/central_hub.tscn"

var dock # A class member to hold the dock during the plugin lifecycle

func _enter_tree():
    # Initialization of the plugin goes here
    # First load the dock scene and instance it:
	dock = preload("res://addons/map_maker/button.tscn").instance()

    # Add the loaded scene to the docks:
	 #add_control_to_dock(DOCK_SLOT_RIGHT_UR, dock)
	add_control_to_container(CONTAINER_TOOLBAR, dock)
	
	dock.connect("pressed", self, "generate_map")

    # Note that LEFT_UL means the left of the editor, upper-left dock

func _exit_tree():
    # Clean-up of the plugin goes here
    # Remove the scene from the docks:
    remove_control_from_docks(dock) # Remove the dock
    dock.free() # Erase the control from the memory
	
func find_arrival(room, id):
	var arrival = null
	for child in room.get_children():
		if(child.is_in_group("warp_arrival")):
			if(child.get_arrival_ID() == id):
				arrival = child
		else:
			var new = find_arrival(child, id)
			
			if(new):
				arrival = new
	
	return arrival
func find_room(node):
	var current_room = node
	
	while(not current_room.is_in_group("room")):
		current_room = current_room.get_parent()
		
	return current_room

func generate_map():
	print("GELLO")
	var window = preload("res://addons/map_maker/window.tscn").instance()
	get_tree().get_root().add_child(window)
	
	var container = window.get_node("container")
	var warptiles = []
	var checked_tiles = []
	var checked_rooms = []
	var counter = 0
	var max_counter = 100
	var room_size = Vector2(1664, 960)
	var position = Vector2(6000, 2000)
	var minimum = Vector2()
	var maximum = Vector2()
	
	checked_rooms.push_back(starting_room)
	var current_room = load(starting_room).instance()
	current_room.position = position
			
	position += Vector2(room_size.x,0)
	container.add_child(current_room)
	for child in current_room.get_children():
		if(child.is_in_group("warp_tile")):
			if(not checked_tiles.has(child)):
				warptiles.push_back(child)
	#print(warptiles)
	while(warptiles.size() and counter < max_counter):
		counter += 1
#		print(warptiles)
		var current_tile = warptiles.pop_back()
		checked_tiles.push_back(current_tile)
#		print("--------")
#		print("Handling: ",current_tile.name)
#		print("Located in: ", current_tile.get_parent().name)
#		print("Finding in: ", current_tile.get_destination_room())
		if(current_tile.get_destination_room() != null and not checked_rooms.has(current_tile.get_destination_room())):
			checked_rooms.push_back(current_tile.get_destination_room())
			current_room = load(current_tile.get_destination_room()).instance()
			
			#print(current_tile.global_position)
			
			var new_pos = current_tile.position/ room_size
			
			new_pos.x = round(new_pos.x)
			new_pos.y = round(new_pos.y)
			
			new_pos *= room_size
			
			current_room.position = new_pos + current_tile.get_parent().position
			
			maximum.x = max(current_room.position.x, maximum.x)
			maximum.y = max(current_room.position.y, maximum.y)
			minimum.x = min(current_room.position.x, minimum.x)
			minimum.y = min(current_room.position.y, minimum.y)
			
			
			position += Vector2(room_size.x,0)
			var nodereino = Node2D.new()
			container.add_child(nodereino)
			nodereino.add_child(current_room)
#
#			print("Attempting to find: ", current_tile.get_arrival_pos_id())
#			print("In: ",current_tile.get_destination_room()) 
			var arrival = find_arrival(current_room, current_tile.get_arrival_pos_id())
			
			if(arrival):
				if(arrival.has_map_making_offset):
					current_room.position -= arrival.map_making_offset * room_size
				else:
					new_pos = current_room.to_local(arrival.global_position) / room_size
					
					new_pos.x = round(new_pos.x)
					new_pos.y = round(new_pos.y)
					
					new_pos *= room_size
					
					current_room.position -= new_pos
			else:
				print("NOT FOUND")
			
			for child in current_room.get_children():
				if(child.is_in_group("warp_tile")):
					if(not checked_tiles.has(child)):
						warptiles.push_back(child)
		else:
			#print("Already checked")
			pass
		if(counter== 33):
			print("e")
	container.position = (-minimum + room_size)* container.scale
	window.get_node("HScrollBar").min_value = (minimum.x - room_size.x) * container.scale.x
	window.get_node("HScrollBar").max_value = (maximum.x+ room_size.x) * container.scale.x - window.rect_size.x
	window.rect_position = Vector2(0, 200)
	window.show()
	window.get_close_button().connect("pressed", container, "free")