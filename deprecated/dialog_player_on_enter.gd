extends Area2D

export(String, FILE, "*.json") var dialog_tree 

func _on_dialog_player_on_enter_body_entered(body):
	get_node("/root/DIALOG_SYSTEM").queue_tree_from_json(dialog_tree)

func start_dialog_and_pause():
	pass