extends "res://scripts/player_enter_trigger.gd"




func _on_on_enter_cutscene_player_player_entered(player):
	if(has_node("AnimationPlayer")):
		get_node("AnimationPlayer").play("cutscene")
	else:
		print("Cutscene not found!")
