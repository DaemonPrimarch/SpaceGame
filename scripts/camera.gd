extends Camera2D

func _ready():
	if(not get_tree().is_connected("tree_changed", self, "update_limit")):
		get_tree().connect("tree_changed", self, "update_limit")

func update_limit():
	#This is_inside_tree might be a hack, get_tree returns null when self is not in tree
	if(is_inside_tree()):
		var terrains = get_tree().get_nodes_in_group("terrain")
			
		if(terrains.size() >= 1):
			var posX = []
			var posY = []
			var terrain_found = false
			var total_size = Vector2()
			
			for terrain in terrains:
				if(terrain extends TileMap):
					terrain_found = true
					posX.append((terrain.get_used_rect().pos.x*terrain.get_cell_size().x + terrain.get_pos().x))
					posY.append((terrain.get_used_rect().pos.y*terrain.get_cell_size().y + terrain.get_pos().y))
					total_size += (terrain.get_used_rect().size * terrain.get_cell_size())
				
			if(terrain_found):
				var min_x = min_arr(posX)
				var min_y = min_arr(posY)
				
				set_limit(0, min_x)
				set_limit(1, min_y)
				set_limit(2, min_x + total_size.x)
				set_limit(3, min_y + total_size.y)

func min_arr(arr):
    var min_val = arr[0]

    for i in range(1, arr.size()):
        min_val = min(min_val, arr[i])

    return min_val
	
	
	