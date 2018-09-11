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

func explode_around(position, radius = 3):
	print(world_to_map(position))
	var nearest_grid_id = world_to_map(position)
	for i in range(nearest_grid_id.x - radius, nearest_grid_id.x + radius + 1):
		for j in range(nearest_grid_id.y - radius - 1, nearest_grid_id.y + radius):
			if(position.distance_to(map_to_world(Vector2(i,j))) < radius * 64):
				set_cell(i,j,-1)
			
	