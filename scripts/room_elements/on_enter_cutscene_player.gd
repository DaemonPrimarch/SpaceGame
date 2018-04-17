extends Node2D

func _on_enter_trigger_player_entered(player):
	if(has_node("cutscene_player")):
		print("PLAYYYYYYYY")
		get_node("cutscene_player").play_cutscene()
	else:
		print("Cutscene not found!")
