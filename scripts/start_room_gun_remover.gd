extends Node2D

func on_player_entered(player):
	player.get_node("weapon_manager").set_enabled(false)
