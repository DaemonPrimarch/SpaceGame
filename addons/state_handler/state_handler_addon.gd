tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("StateHandler", "Node2D", preload("state_handler.gd"), preload("kinematic_body_2D.svg"))

func _exit_tree():
	remove_custom_type("StateHandler")