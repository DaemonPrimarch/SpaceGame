extends Node2D

func _on_room_player_enter(player):
	if(player.get_save_data()["goo_key_2"] == true):
		get_node("goo").set_active(true)
		get_node("TileMap").set_active(true)
	else:
		get_node("goo").set_active(false)
		get_node("TileMap").set_active(false)
