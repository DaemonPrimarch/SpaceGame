extends Node2D

var loaded = false
export var destination_scene_path = "res://nodes/rooms/"
export var arrival_node_ID = "arrival_name"

func on_enter(body):
	if(body.is_in_group("warpable") and not loaded):
		if(destination_scene_path == "res://nodes/rooms/"):
			print("door not loaded")
		else:
			room_loader.call_deferred("warp_player_to_new_room", body, destination_scene_path, arrival_node_ID)