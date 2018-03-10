extends Node

func calculate_jump_starting_velocity_y(height, acceleration_y):
	return -calculate_jump_max_airtime(height, acceleration_y) * acceleration_y

func calculate_jump_max_airtime(height, acceleration_y):
	var D = 1 + 2 * acceleration_y * height
	
	return (-1 + sqrt(D))/acceleration_y