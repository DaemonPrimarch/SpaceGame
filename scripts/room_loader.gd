extends Node

func warp_player_to_new_room(player, path, position_id):
	var old_scene = player.get_parent()
	
	old_scene.remove_child(player)
	
	get_tree().get_root().remove_child(old_scene)
	
	#old_scene.queue_free()

	var new_scene = load(path).instance()
	
	#Ugly hack
	new_scene.set_pos(Vector2(10000, 10000))
	get_tree().get_root().add_child(new_scene)
	
	var nodes_in_group = new_scene.get_tree().get_nodes_in_group("warp_arrival")
	var nb_of_found_nodes = 0
	
	for node in nodes_in_group:
		if(node.get_name() == position_id):
			player.set_global_pos(node.get_pos())
			nb_of_found_nodes += 1
			#		
			if(nb_of_found_nodes >= 2):
				raise("error")
				
	new_scene.add_child(player)
	
	#Ugly hack
	new_scene.set_pos(Vector2(0,0))
	
	new_scene.emit_signal("player_enter", player)