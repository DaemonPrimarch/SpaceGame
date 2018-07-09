extends "res://scripts/helpers/cutscene_helper.gd"

func _physics_process(delta):
	var player = ROOM_MANAGER.get_room_of_node(self).get_node("player")
	var puppet = get_node("../puppet_1")

	var min_speed = 162
	
	if(player.global_position.x > puppet.global_position.x + 64 +32):
		print(player.get_max_movement_speed())
		player.set_movement_speed(min(162 + ( player.global_position.x - puppet.global_position.x)/2, player.get_max_movement_speed()))
	else:
		player.set_movement_speed(162)