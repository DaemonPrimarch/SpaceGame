tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("ExtendedArea2D", "Area2D", preload("extended_area_2D.gd"), null)

func _exit_tree():
	remove_custom_type("ExtendedArea2D")