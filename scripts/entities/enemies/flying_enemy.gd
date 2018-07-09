extends "res://scripts/entities/enemies/enemy.gd"

onready var path_follower = get_parent()

func _init():
	add_state("FLY_PATTERN")
	
func _on_object_hit( body ):
	pass # replace with function body

func destroy():
	.destroy()
	get_node("../../..").queue_free()