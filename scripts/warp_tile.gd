tool

extends Area2D

signal activated
signal deactivated

signal destination_room_changed

export var active = true setget set_active, is_active
export(String, FILE, "*.tscn")var destination_room setget set_destination_room, get_destination_room
export var arrival_pos_id = "" setget set_arrival_pos_id, get_arrival_pos_id

func _ready():
	pass

func is_active():
	return active
	
func set_active(val):
	active = val
	
	if(val):
		emit_signal("activated")
	else:
		emit_signal("deactivated")

func set_destination_room(room):
	destination_room = room
	
	emit_signal("destination_room_changed")

func has_destination_room():
	return destination_room != null

func get_destination_room():
	return destination_room
	
func set_arrival_pos_id(id):
	arrival_pos_id = id

func get_arrival_pos_id():
	return arrival_pos_id

func on_body_enter( body ):	
	if(is_active() and body.is_in_group("warpable") and has_destination_room()):
		get_node("/root/ROOM_MANAGER").call_deferred("warp_node_to_room",body, get_destination_room(), get_arrival_pos_id())
