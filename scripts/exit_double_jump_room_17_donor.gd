extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func get_signal():
	get_tree().get_nodes_in_group("player")[0].get_save_data()["goo_key_2"] = true
