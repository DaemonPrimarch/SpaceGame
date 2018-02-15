tool

extends "res://scripts/warp_tile.gd"

export var flippedH = false setget set_flippedH, is_flippedH
export var flippedV = false setget set_flippedV, is_flippedV

func _ready():
	var parent_room = self
	
	set_arrival_pos_id(get_parent().get_name() + "_arrival")
	
	on_change_name()

func on_change_name():
	if(get_destination_room() != null):
		var name = get_destination_room().right(get_destination_room().find_last("/") + 1)
		name = name.left(name.find_last(".tscn"))
		
		for node in get_children():
			if(node is Position2D):
				node.set_arrival_ID(name + "_arrival")
		
func is_flippedH():
	return flippedH

func is_flippedV():
	return flippedV
	
func set_flippedH(val):
	if(val != is_flippedH()):
		for child in get_children():
			if(child is Node2D):
				child.set_scale(child.get_scale() * Vector2(-1,1))
				child.set_position(child.get_position() * Vector2(-1,1))
				child.set_rotation(-child.get_rotation())
	
	flippedH = val

func set_flippedV(val):
	if(val != is_flippedV()):
		for child in get_children():
			if(child is Node2D):
				child.set_scale(child.get_scale() * Vector2(1,-1))
				child.set_position(child.get_position() * Vector2(1,-1))
	
	flippedV = val