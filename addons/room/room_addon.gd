tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Room", "Node2D", preload("room.gd"), null)

func _exit_tree():
	remove_custom_type("Room")