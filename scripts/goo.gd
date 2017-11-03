extends "res://scripts/hazard_area.gd"

func _on_room_player_enter(player):
	if(player.get_save_data().has("goo_key") and player.get_save_data()["goo_key"]):
		set_active(false)
