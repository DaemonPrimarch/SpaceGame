extends Node

export var in_background = false setget set_in_background, is_in_background
export var linked_to_parent = false

func _ready():
	get_parent().add_to_group("layer_changeable")
	
	set_in_background(is_in_background())

func set_in_background(val):
	if(is_inside_tree()):
		if(not val and is_in_background()):
			if(not get_parent() is RayCast2D ):
				get_parent().collision_layer /= 256
			get_parent().collision_mask  /= 256
		if(val):
			if(not get_parent() is RayCast2D ):
				get_parent().collision_layer *= 256
				
			get_parent().collision_mask *= 256
		
		for child in get_parent().get_children():
			if(child.is_in_group("layer_changeable") and child.get_node("LayerChanger").is_linked_to_parent()):
				child.get_node("LayerChanger").set_in_background(val)

	in_background = val
func is_in_background():
	return in_background

func is_linked_to_parent():
	return linked_to_parent