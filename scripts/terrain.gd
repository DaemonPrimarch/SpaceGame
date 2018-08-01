tool
extends TileMap

func get_AABB():
	var rect = get_used_rect()
	
	rect.position *= cell_size
	rect.position += global_position
	rect.size *= cell_size
	
	return rect