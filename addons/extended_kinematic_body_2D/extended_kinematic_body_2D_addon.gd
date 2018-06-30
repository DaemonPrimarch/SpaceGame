tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("ExtendedKinematicBody2D", "KinematicBody2D", preload("extended_kinematic_body_2D.gd"), preload("kinematic_body_2D.svg"))
	print("Added type")

func _exit_tree():
	remove_custom_type("ExtendedKinematicBody2D")