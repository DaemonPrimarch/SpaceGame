extends Node2D

func _on_enter_trigger_player_entered(player):
	if(has_node("cutscene_player")):
		get_node("cutscene_player").play_cutscene()
	else:
		print("Cutscene not found!")

func cutscene_finished():
	queue_free()

func _on_enter_trigger_tree_exited():
	if(not get_node("cutscene_player").is_playing()):
		queue_free()
	else:
		get_node("cutscene_player").connect("cutscene_finished", self, "cutscene_finished")
