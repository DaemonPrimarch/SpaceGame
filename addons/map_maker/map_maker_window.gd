tool

extends WindowDialog

var zoom = 10

var max_x = 0
var min_x = 0

onready var sprite_map = get_node("map/sprite_map")
onready var room_map = get_node("map/room_map")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func get_zoom():
	return zoom

func get_starting_scene():
	return "res://nodes/rooms/central_hub_room.tscn"

func round_in_room(pos):
	var r_pos = Vector2(pos.x, pos.y)
	
	r_pos.x = int((r_pos.x + 64 * 10)/ (64 * 20)) * 64 * 20
	r_pos.y = int((r_pos.y + 64 * 5.5) / (64 * 11)) * 64 * 11
	
	return r_pos
	
func round_in_room_x(pos):
	var r_pos = Vector2(pos.x, pos.y)
	
	r_pos.x = int((r_pos.x + 64 * 10)/ (64 * 20)) * 64 * 20
	
	return r_pos

func round_in_room_y(pos):
	var r_pos = Vector2(pos.x, pos.y)
	
	r_pos.y = int((r_pos.y + 64 * 5.5) / (64 * 11)) * 64 * 11
	
	return r_pos



func load_map():
	print("LOADING MAP")
	
	max_x = 0

	var rooms_to_load = []
	var handled_rooms = {}
	var found_rooms = []

	rooms_to_load.push_back({room = get_starting_scene(), pos = round_in_room(get_size() * get_zoom()/2 * Vector2(1, 0) + Vector2(3000, 3000)), warp_pos = Vector2(), warp_id = ""})
	handled_rooms[get_starting_scene()] = true
	min_x = (get_size() * get_zoom()/2 * Vector2(1, 0)).x
	var max_depth = 500
	var depth = 0
	
	var current_room_path
	var current_room
	var current_room_pos
	
	while(rooms_to_load.size() > 0):
		var info = rooms_to_load[rooms_to_load.size() - 1]
		rooms_to_load.pop_back()
		
		current_room_path = info.room
				
		print("ATTEMPTING TO LOAD: ", current_room_path)
		current_room = load(current_room_path).instance()
		current_room.set_hidden(true)
		
		add_child(current_room)
		
		var warp_arrivals = current_room.get_tree().get_nodes_in_group("warp_arrival")
		var arrival_pos = Vector2()
		
		if(info.warp_id != ""):
			for node in warp_arrivals:
				if(node.get_name() == info.warp_id):
					print("Arrival position: ", node.get_pos())
					arrival_pos = node.get_pos()
		
			current_room_pos = round_in_room(info.pos + (info.warp_pos - arrival_pos))
		else:
			current_room_pos = info.pos
		
		"""Drawing Tiles:"""
		
		var new_tile = preload("res://addons/map_maker/tile.tscn").instance()
		
		new_tile.set_pos((current_room_pos + current_room.get_used_rect().pos)/ get_zoom())
		
		new_tile.set_scale(current_room.get_used_rect().size / Vector2(64 * get_zoom() , 64 * get_zoom()))
		
		if(current_room_path == get_starting_scene()):
			new_tile.set_modulate(Color(0,1,0))
		if(current_room.get_used_rect().pos.y != 0):
			new_tile.set_modulate(Color(0,0,1))
		
		sprite_map.add_child(new_tile)
		
		"""Saving Maps"""
		
		found_rooms.push_back({pos = (current_room_pos) / get_zoom(), scale = Vector2(1.0, 1.0) / float(get_zoom()), room = current_room_path, rect = current_room.get_used_rect()})
		
		if(((current_room_pos) / get_zoom()).x < min_x):
			min_x = ((current_room_pos) / get_zoom()).x 
		
		if(((current_room_pos) / get_zoom()).x + current_room.get_used_rect().size.x > max_x):
		 	max_x = ((current_room_pos) / get_zoom()).x + current_room.get_used_rect().size.x
		
		var tiles = current_room.get_tree().get_nodes_in_group("warp_tile")
		
		for warptile in tiles:
			#if(not warptile.get_destination_path() == ""):
			#	found_warp_tiles.push_back({pos = warptile.get_global_pos() + current_room_pos, rot = warptile.get_global_rot(), scale = warptile.get_global_scale()})
			
			if(not handled_rooms.has(warptile.get_destination_path()) and not warptile.get_destination_path() == "" and depth < max_depth):
				rooms_to_load.push_back({room = warptile.get_destination_path(), pos = Vector2(current_room_pos), warp_pos = warptile.get_global_pos() - current_room.get_global_pos(), warp_rot = warptile.get_rot(), warp_id = warptile.arrival_node_ID, rect = current_room.get_used_rect()})
				handled_rooms[warptile.get_destination_path()] = true
				depth += 1

		remove_child(current_room)
	
	for r in found_rooms:
		var new_room = load(r.room).instance()
		
		new_room.set_pos(r.pos)
		
		new_room.set_scale(r.scale)
		
		room_map.add_child(new_room)
	
	"""for tile in found_warp_tiles:
		var new_tile = preload("res://addons/map_maker/tile.tscn").instance()
		new_tile.set_pos(tile.pos/ get_zoom())
		
		new_tile.set_scale(tile.scale / get_zoom())
		new_tile.set_rot(tile.rot)
		
		new_tile.set_modulate(Color(0,0,1))
		
		window.add_child(new_tile)"""
		
	get_node("scrollbar").set_max(max_x)
	get_node("scrollbar").set_min(min_x)
	get_node("scrollbar").set_value((max_x - min_x) / 2)
		
func unload_map():
	print("UNLOADING MAP")
	for n in room_map.get_children():
		n.free()
	
	for n in sprite_map.get_children():
		n.free()

func _on_room_map_toggled( pressed ):
	get_node("map/room_map").set_hidden(!pressed)
	
func _on_sprite_map_toggled( pressed ):
	get_node("map/sprite_map").set_hidden(!pressed)


func _on_scrollbar_value_changed( value ):
	get_node("map").set_pos(Vector2((max_x - min_x)/2 - value, get_node("map").get_pos().y))
