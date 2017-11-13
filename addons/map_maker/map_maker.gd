tool

extends EditorPlugin

var button

var zoom = 10

func _enter_tree():
	button = preload("res://addons/map_maker/button.tscn").instance()
	
	button.connect("pressed", self, "draw_map")
	
	add_control_to_container(CONTAINER_TOOLBAR, button)

func _exit_tree():
	button.free()

func get_zoom():
	return zoom

func get_starting_scene():
	return "res://nodes/rooms/piet_room_1.tscn"

func round_in_room(pos):
	var r_pos = Vector2(pos.x, pos.y)
	
	r_pos.x = int((r_pos.x + 64 * 10)/ (64 * 20)) * 64 * 20
	r_pos.y = int((r_pos.y + 64 * 5.5) / (64 * 11)) * 64 * 11
	
	return r_pos
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func draw_map():
	var scenes = []
	var handled_scenes = {}
	var found_warp_tiles = []
	var current_room_pos
	
	var window = preload("res://addons/map_maker/map_window.tscn").instance()
	add_child(window)
	
	window.popup()
		
	scenes.push_back({room = get_starting_scene(), pos = window.get_size() * get_zoom()/2, warp_pos = Vector2(), warp_id = ""})
	handled_scenes[get_starting_scene()] = true
	
	var max_depth = 4
	var depth = 0
	var current_scene_path
	var current_room
	
	while(scenes.size() > 0):
		var obj = scenes[scenes.size() - 1]
		current_scene_path = obj.room
		scenes.pop_back()
		
		current_room = load(current_scene_path).instance()
		
		current_room.set_hidden(true)
		
		add_child(current_room)
		
		var nodes_in_group = current_room.get_tree().get_nodes_in_group("warp_arrival")
		
		var arrival_pos = Vector2()
		
		if(obj.warp_id != ""):
			for node in nodes_in_group:
				if(node.get_name() == obj.warp_id):
					arrival_pos = (node.get_pos())
		
			current_room_pos = obj.pos + round_in_room(obj.warp_pos) - round_in_room(arrival_pos)
		else:
			print("THIS HAPPENS ONCE")
			current_room_pos = obj.pos
		
		var new_tile = preload("res://addons/map_maker/tile.tscn").instance()
		
		new_tile.set_pos(current_room_pos / get_zoom())
		
		new_tile.set_scale(current_room.get_used_rect().size / Vector2(64 * get_zoom() , 64 * get_zoom()))
		
		if(current_scene_path == get_starting_scene()):
			new_tile.set_modulate(Color(0,1,0))
		
		#window.add_child(new_tile)
		
		var new_room = load(current_scene_path).instance()
		new_room.set_pos((current_room_pos - new_room.get_used_rect().pos) / get_zoom())
		new_room.set_scale(new_room.get_scale() / get_zoom())
		
		window.add_child(new_room)
		 
		var tiles = current_room.get_tree().get_nodes_in_group("warp_tile")
		
		print(current_room.get_name())
		
		for warptile in tiles:
			if(not warptile.get_destination_path() == ""):
				found_warp_tiles.push_back({pos = warptile.get_global_pos() + current_room_pos, rot = warptile.get_global_rot(), scale = warptile.get_global_scale()})
			
			if(not handled_scenes.has(warptile.get_destination_path()) and not warptile.get_destination_path() == "" and depth < max_depth):
				print("Found: ",  warptile.get_destination_path())
				print("Name: ", warptile.get_name())
				scenes.push_back({room = warptile.get_destination_path(), pos = Vector2(current_room_pos), warp_pos = warptile.get_global_pos(), warp_id = warptile.arrival_node_ID})
				handled_scenes[warptile.get_destination_path()] = true
		depth += 1
		remove_child(current_room)
	
	for tile in found_warp_tiles:
		var new_tile = preload("res://addons/map_maker/tile.tscn").instance()
		new_tile.set_pos(tile.pos/ get_zoom())
		
		new_tile.set_scale(tile.scale / get_zoom() * 2)
		new_tile.set_rot(tile.rot)
		
		new_tile.set_modulate(Color(0,0,1))
		
		window.add_child(new_tile)
	