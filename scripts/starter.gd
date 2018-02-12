extends Node2D

export(String, FILE, "*.tscn")var starting_room
export var arrival_pos_id = ""

func _ready():
	get_node("/root/ROOM_MANAGER").add_room_as_loaded(self)
	get_node("/root/ROOM_MANAGER").call_deferred("warp_node_to_room",get_node("player"), starting_room,arrival_pos_id)