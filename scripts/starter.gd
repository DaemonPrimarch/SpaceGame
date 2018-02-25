extends Node2D

export(String, FILE, "*.tscn")var starting_room
export var arrival_pos_id = ""

func _ready():
	get_node("/root/ROOM_MANAGER").add_room_as_loaded(self)
	get_node("/root/ROOM_MANAGER").call_deferred("warp_node_to_room",get_node("player"), starting_room,arrival_pos_id)
	
	var TestTree = {"start": {"name": "POOT", "text": "HELLO WORLD", "next": "second"}, "second": {"name": "STAN", "text": "USUCK", "options": ["A","B","C"], "next": ["start", "last", "last"]}, "last": {"name": "Hype", "text": "worked"}}
	
	#get_node("/root/DIALOG_SYSTEM").queue_tree(TestTree)
	#get_node("/root/DIALOG_SYSTEM").queue_message("Hello There!")