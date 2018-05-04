extends Node

export var in_background = false setget set_in_background, is_in_background

func _ready():
	get_parent().add_to_group("layer_changeable")
	
	set_in_background(is_in_background())

func set_in_background(val):
	if(is_inside_tree()):
		if(not val and is_in_background()):
			get_parent().collision_layer -= 256
			get_parent().collision_mask  -= 256
		if(val):
			get_parent().collision_layer += 256
			get_parent().collision_mask += 256
			
		in_background = val

func is_in_background():
	return in_background
