tool

extends "res://scripts/warp_tile.gd"

func _ready():
	var parent_room = self
	
	set_arrival_pos_id(get_parent().get_name() + "_arrival")

func on_change_name():
	if(Engine.is_editor_hint() and get_destination_room() != null):
		var name = get_destination_room().right(get_destination_room().find_last("/") + 1)
		name = name.left(name.find_last(".tscn"))
		
		for node in get_children():
			if(node is Position2D):
				node.set_arrival_ID(name + "_arrival")
		