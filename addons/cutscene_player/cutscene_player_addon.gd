tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("CutscenePlayer", "AnimationPlayer", preload("cutscene_player.gd"), preload("animation_player.svg"))

func _exit_tree():
	remove_custom_type("CutscenePlayer")