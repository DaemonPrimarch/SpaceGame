tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("HelperArea", "Area2D", preload("helper_area.gd"), preload("extended_animation_player.svg"))

func _exit_tree():
	remove_custom_type("HelperArea")