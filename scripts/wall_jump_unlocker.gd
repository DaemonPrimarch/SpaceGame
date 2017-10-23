extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_area_prompt_trigger_triggered():
	get_tree().get_nodes_in_group("player")[0].set_can_wall_jump(true)
	get_tree().get_nodes_in_group("player")[0].set_can_wall_slide(true)
	
	dialog_system.play_dialog(dialog_system.create_linear_tree(["Wall Jumping unlocked!!!"]))

	queue_free()