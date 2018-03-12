extends Node

func calculate_jump_starting_velocity_y(height, acceleration_y):
	return -calculate_jump_max_airtime(height, acceleration_y) * acceleration_y

func calculate_jump_max_airtime(height, acceleration_y):
	var D = 1 + 2 * acceleration_y * height
	
	return (-1 + sqrt(D))/acceleration_y

func get_global_scale_of_node(node):
	var current_node = node
	var scale = node.scale
	while(current_node.get_parent() != null and "scale" in current_node.get_parent()):
		current_node = current_node.get_parent()
		scale *= current_node.scale
	return scale