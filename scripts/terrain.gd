tool
extends TileMap

func get_AABB():
	var rect = get_used_rect()
	
	rect.position *= cell_size
	rect.position += global_position
	rect.size *= cell_size
	
	return rect

func is_tile_explodable(id):
	return [7].has(id)

func explode_around(position, diameter = 5):
	print(world_to_map(position))
	var nearest_grid_id = world_to_map(position)
	for i in range(nearest_grid_id.x - diameter/2, nearest_grid_id.x + diameter/2 + 1):
		for j in range(nearest_grid_id.y - diameter/2 - 1, nearest_grid_id.y + diameter/2):
			if(is_tile_explodable(get_cell(i,j))):
				set_cell(i,j,-1)
			
	