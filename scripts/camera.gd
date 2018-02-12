extends Camera2D

func _ready():
	set_process(true)
	update_limit()

func _process(delta):
	pass
	
func update_limit():
	var terrains = get_tree().get_nodes_in_group("terrain")
			
	if(terrains.size() >= 1):
		var min_posX = []
		var min_posY = []
		var max_posX = []
		var max_posY = []
		
		var found = false
			
		for terrain in terrains:
			if(terrain is TileMap):
				found = true
					
				min_posX.append((terrain.get_used_rect().position.x*terrain.get_cell_size().x + terrain.get_global_position().x))
				min_posY.append((terrain.get_used_rect().position.y*terrain.get_cell_size().y + terrain.get_global_position().y))
				max_posX.append((terrain.get_used_rect().position.x*terrain.get_cell_size().x + terrain.get_global_position().x + terrain.get_used_rect().size.x * terrain.get_cell_size().x))
				max_posY.append((terrain.get_used_rect().position.y*terrain.get_cell_size().y + terrain.get_global_position().y + terrain.get_used_rect().size.y * terrain.get_cell_size().y))
		if(found):
			set_limit(0, MATHS.min_arr(min_posX))
			set_limit(1, MATHS.min_arr(min_posY))
			set_limit(2, MATHS.max_arr(max_posX))
			set_limit(3, MATHS.max_arr(max_posY))
