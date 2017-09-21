extends Camera2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	var terrains = get_tree().get_nodes_in_group("terrain")
	
	if(terrains.size() >= 1):
	
		var posX = []
		var posY = []
		
		var total_size = Vector2()
		
		for terrain in terrains:
			posX.append(terrain.get_used_rect().pos.x)
			posY.append(terrain.get_used_rect().pos.y)
			total_size += (terrain.get_used_rect().size * terrain.get_cell_size())
			
		set_limit(0, min_arr(posX))
		set_limit(1, min_arr(posY))
		set_limit(2, total_size.x)
		set_limit(3, total_size.y)
	
	set_process(true)

func min_arr(arr):
    var min_val = arr[0]

    for i in range(1, arr.size()):
        min_val = min(min_val, arr[i])

    return min_val

func _process(delta):

	var terrains = get_tree().get_nodes_in_group("terrain")
	if(terrains.size() >= 1):
		var posX = []
		var posY = []
		
		var total_size = Vector2()
		
		for terrain in terrains:
			posX.append(terrain.get_used_rect().pos.x)
			posY.append(terrain.get_used_rect().pos.y)
			total_size += (terrain.get_used_rect().size * terrain.get_cell_size())
			
		set_limit(0, min_arr(posX))
		set_limit(1, min_arr(posY))
		set_limit(2, total_size.x)
		set_limit(3, total_size.y)
	
	