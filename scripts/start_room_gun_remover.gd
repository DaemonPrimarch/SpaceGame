extends Node2D

func player_entered(player):
	player.get_node("weapon_manager").set_enabled(false)
