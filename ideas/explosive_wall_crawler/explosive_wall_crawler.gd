tool

extends "res://scripts/entities/enemies/enemy.gd"

var explosion_diameter = 6

func _init():
	add_state("BACK_FORTH")

func crush():
	destroy()

func explode():
	var tilemap = get_node("/root/ROOM_MANAGER").get_room_of_node(self).get_node("terrain")
	var nearest_grid_id = find_nearest_grid_id(position)
	for i in range(nearest_grid_id.x - explosion_diameter/2, nearest_grid_id.x + explosion_diameter/2 + 1):
		for j in range(nearest_grid_id.y - explosion_diameter/2 - 1, nearest_grid_id.y + explosion_diameter/2):
			tilemap.set_cell(i,j,-1)

func destroy():
	explode()
	.destroy()

func find_nearest_grid_id(pos):
	return Vector2((int(pos.x)/64), (int(pos.y)/64))