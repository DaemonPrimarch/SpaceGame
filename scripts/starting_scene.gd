extends Node2D

var loaded = false
var first = true
export var destination_scene_path = "path"
export var arrival_node_ID = "arrival_name"

func _ready():
	room_loader.call_deferred("warp_player_to_new_room_path", get_node("player"), destination_scene_path, arrival_node_ID)