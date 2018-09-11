tool

extends "res://scripts/entities/enemies/enemy.gd"

var explosion_diameter = 6

func _init():
	add_state("BACK_FORTH")

func crush():
	destroy()

func explode():
	for terrain in get_tree().get_nodes_in_group("terrain"):
		terrain.explode_around(global_position)

func destroy():
	explode()
	.destroy()

func find_nearest_grid_id(pos):
	return Vector2((int(pos.x)/64), (int(pos.y)/64))