tool

extends "res://scripts/entities/enemies/enemy.gd"

var explosion_diameter = 6

func _init():
	add_state("BACK_FORTH")

func crush():
	destroy()

func explode():
#	for terrain in get_tree().get_nodes_in_group("terrain"):
#		terrain.explode_around(global_position)
	var explosion = preload("res://nodes/explosion.tscn").instance()
	explosion.global_position = global_position
	get_node("/root/ROOM_MANAGER").get_room_of_node(self).add_child(explosion)
	
	explosion.call_deferred("explode")

func destroy():
	explode()
	.destroy()

func find_nearest_grid_id(pos):
	return Vector2((int(pos.x)/64), (int(pos.y)/64))