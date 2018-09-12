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
	var nearest_grid_id = world_to_map(position)
	for i in range(nearest_grid_id.x - radius, nearest_grid_id.x + radius + 1):
		for j in range(nearest_grid_id.y - radius - 1, nearest_grid_id.y + radius):
			if(position.distance_to(map_to_world(Vector2(i,j))) < radius * 64 and is_tile_explodable(get_cell(i,j))):
				set_cell(i,j,-1)
				var node = preload("res://nodes/terrain_explosion_particles.tscn").instance()
				node.global_position = map_to_world(Vector2(i,j))
				node.restart()
				add_child(node)
			
	