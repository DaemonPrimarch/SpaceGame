tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("PlayerEnterTrigger", "Area2D", preload("player_enter_trigger.gd"), preload("kinematic_body_2D.svg"))

func _exit_tree():
	remove_custom_type("PlayerEnterTrigger")