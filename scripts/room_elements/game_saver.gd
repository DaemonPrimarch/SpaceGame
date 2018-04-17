extends "res://scripts/player_enter_trigger.gd"

func _on_game_saver_player_entered(player):
	player.set_HP(player.get_max_HP())
	
	DIALOG_SYSTEM.queue_message("GAME SAVED!")
	SAVE_MANAGER.save_current_file()
