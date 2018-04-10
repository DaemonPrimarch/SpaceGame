tool

extends Position2D

export var arrival_ID = ""
export var has_map_making_offset = false
export var map_making_offset = Vector2()

func get_arrival_ID():
	return arrival_ID

func set_arrival_ID(id):
	arrival_ID = id
