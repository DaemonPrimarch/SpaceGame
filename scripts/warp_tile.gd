tool

extends Node2D

var loaded = false
export var active = true setget set_active, is_active
export var arrival_node_ID = "arrival_name"
export(String, FILE, "*.tscn") var destination_scene_path = "" setget destination_path_changed

func _ready():
	if(destination_scene_path != ""):
		get_node("sprite").set_modulate(Color(0, 1, 0, 1))

func on_enter(body):
	if(body.is_in_group("warpable") and not loaded):
		if(destination_scene_path == ""):
			print("door not loaded")
		else:
			get_node("/root/room_loader").call_deferred("warp_player_to_new_room_path", body, destination_scene_path, arrival_node_ID)
			
func is_active():
	return active

func set_active(value):
	active = true
	
	if(has_node("sprite")):
		get_node("sprite").set_hidden(not value)
	if(has_node("area")):
		get_node("area").set_layer_mask_bit(0, value)

func destination_path_changed(new_path):
	if(has_node("sprite")):
		if(new_path != ""):
			get_node("sprite").set_modulate(Color(0, 1, 0, 1))
		else:
			get_node("sprite").set_modulate(Color(1, 0, 0, 1))
	
	destination_scene_path = new_path