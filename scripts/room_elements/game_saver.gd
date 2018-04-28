extends "res://scripts/player_enter_trigger.gd"

func save_and_recharge(player):
	player.set_HP(player.get_max_HP())
	
	DIALOG_SYSTEM.queue_message("GAME SAVED!")
	SAVE_MANAGER.save_current_file()

func save_and_recharge_np():
	print("SAVVV")
	save_and_recharge(get_node("/root/ROOM_MANAGER").get_room_of_node(self).get_node("player"))