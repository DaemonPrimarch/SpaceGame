tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("HelperArea", "Area2D", preload("helper_area.gd"), preload("area.svg"))

func _exit_tree():
	remove_custom_type("HelperArea")