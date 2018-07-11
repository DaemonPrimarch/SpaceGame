extends Node2D

func _ready():
	$enter_trigger.connect("player_entered", self, "_on_enter_trigger_player_entered")
	$enter_trigger.connect("tree_exited", self, "_on_enter_trigger_player_exited")

func _on_enter_trigger_player_entered(player):
	if(has_node("CutscenePlayer")):
		get_node("CutscenePlayer").start_cutscene()
	else:
		print("Cutscene not found!")

func cutscene_finished():
	queue_free()

func _on_enter_trigger_tree_exited():
	if(not get_node("CutscenePlayer").is_playing()):
		queue_free()
	else:
		get_node("CutscenePlayer").connect("cutscene_finished", self, "cutscene_finished")