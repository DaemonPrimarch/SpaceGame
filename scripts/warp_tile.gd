extends Node2D

var loaded = false
export var destination_scene_path = "path"
export var arrival_node_ID = "arrival_name"

func on_enter(body):
	if(body.is_in_group("warpable") and not loaded):
		if(destination_scene_path == "path"):
			print("door not loaded")
		else:
			scene_loader.call_deferred("warp_player_to_new_scene", body, destination_scene_path, arrival_node_ID)


func _ready():
	pass