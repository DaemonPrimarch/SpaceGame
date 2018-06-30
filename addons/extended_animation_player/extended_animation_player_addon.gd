tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("ExtendedAnimationPlayer", "AnimationPlayer", preload("extended_animation_player.gd"), preload("extended_animation_player.svg"))

func _exit_tree():
	remove_custom_type("ExtendedAnimationPlayer")