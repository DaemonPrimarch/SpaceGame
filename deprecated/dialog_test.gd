tool

extends "res://scripts/room_elements/bullet_switch.gd"

export(String, FILE, "*.json") var dialog 

func _on_bullet_switch_switched_on():
	get_node("/root/DIALOG_SYSTEM").queue_tree_from_json(dialog)
