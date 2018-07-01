tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("CutscenePlayer", "AnimationPlayer", preload("cutscene_player.gd"), preload("kinematic_body_2D.svg"))

func _exit_tree():
	remove_custom_type("CutscenePlayer")