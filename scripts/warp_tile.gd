extends Node2D

var loaded = false
export var active = true setget set_active, is_active
export var destination_scene_path = "res://nodes/rooms/"
export var arrival_node_ID = "arrival_name"

func on_enter(body):
	if(body.is_in_group("warpable") and not loaded):
		if(destination_scene_path == "res://nodes/rooms/"):
			print("door not loaded")
		else:
			room_loader.call_deferred("warp_player_to_new_room", body, destination_scene_path, arrival_node_ID)

func is_active():
	return active

func set_active(value):
	active = true
	
	if(has_node("sprite")):
		get_node("sprite").set_hidden(not value)
	if(has_node("area")):
		get_node("area").set_layer_mask_bit(0, value)