extends Button


func _on_FileDialog_file_selected(path):
	for node in get_tree().get_nodes_in_group("player"):
		SAVE_MANAGER.set_property("player/room", ROOM_MANAGER.get_path_of_room(ROOM_MANAGER.get_room_of_node(node)))
		SAVE_MANAGER.set_property("player/position_x", ROOM_MANAGER.get_room_of_node(node).to_local(node.global_position).x)
		SAVE_MANAGER.set_property("player/position_y", ROOM_MANAGER.get_room_of_node(node).to_local(node.global_position).y)
		print("PATH", ROOM_MANAGER.get_path_of_room(ROOM_MANAGER.get_room_of_node(node)))
	
	
	SAVE_MANAGER.save_current_file(path)


func _on_save_button_pressed():
	#$FileDialog.popup()
	pass
