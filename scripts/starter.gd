extends Node2D

export(String, FILE, "*.tscn")var starting_room
export var arrival_pos_id = ""


func _ready():
	
	var TestTree = {"start": {"name": "POOT", "text": "HELLO WORLD", "next": "second"}, "second": {"name": "STAN", "text": "USUCK", "options": ["A","B","C"], "next": ["start", "last", "last"]}, "last": {"name": "Hype", "text": "worked"}}
	
	#get_node("/root/DIALOG_SYSTEM").queue_tree(TestTree)
	#get_node("/root/DIALOG_SYSTEM").queue_message("Hello There!"
	
	$player.set_physics_process(false)
	
	get_node("/root/ROOM_MANAGER").add_room_as_loaded(self, "STARTING_ROOM")


func _on_new_game_pressed():
	load_first_scene(starting_room, arrival_pos_id)
	
func load_first_scene(path, arrival_id):
	get_node("player/ExtendedCamera2D").current = true
	$player.set_physics_process(true)
	
	get_node("/root/ROOM_MANAGER").call_deferred("warp_node_to_room",get_node("player"), path, arrival_id)

func _on_load_game_pressed():
	$start_panel/FileDialog.popup()

func _on_FileDialog_file_selected(path):
	SAVE_MANAGER.load_file(path)
	
	if(SAVE_MANAGER.has_property("player/room")):
		load_first_scene(SAVE_MANAGER.get_property("player/room"), Vector2(SAVE_MANAGER.get_property("player/position_x"), SAVE_MANAGER.get_property("player/position_y")))
	else:
		$start_panel/AcceptDialog.popup()
		
		_on_new_game_pressed()
	