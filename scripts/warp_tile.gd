extends Node2D

var loaded = false
export var active = true setget set_active, is_active
export var arrival_node_ID = "arrival_name"
export(PackedScene) var destination_scene

func on_enter(body):
	if(body.is_in_group("warpable") and not loaded):
		if(destination_scene == null):
			print("door not loaded")
		else:
			room_loader.call_deferred("warp_player_to_new_room_packed", body, destination_scene, arrival_node_ID)
			
func is_active():
	return active

func set_active(value):
	active = true
	
	if(has_node("sprite")):
		get_node("sprite").set_hidden(not value)
	if(has_node("area")):
		get_node("area").set_layer_mask_bit(0, value)