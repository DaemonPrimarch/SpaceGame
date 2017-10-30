extends Node2D

func _on_room_player_enter(player):
	if(player.get_save_data().has("goo_key_2") and player.get_save_data()["goo_key_2"] == true):
		get_node("goo").set_active(true)
	else:
		get_node("goo").set_active(false)
		get_node("TileMap").set_collision_layer(0)
		get_node("TileMap").set_hidden(true)
