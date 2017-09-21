extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var loaded = false
export var destination_scene_path = "path"
export var arrival_node_ID = "arrival_name"

func on_enter(body):
	if(body.is_in_group("warpable") and not loaded):
		loaded = true
		body.set_is_warping(true)
		var loaded_scene = load(destination_scene_path).instance()
		var original_scene = body.get_parent()
		get_tree().get_root().add_child(loaded_scene)
		original_scene.remove_child(body)
		loaded_scene.add_child(body)
		original_scene.set_pos(Vector2(100000000,100000000))
		original_scene.queue_free()
		for node in loaded_scene.get_tree().get_nodes_in_group("warp_arrival"):
			if(node.get_name() == arrival_node_ID):
				body.set_global_pos(node.get_global_pos())
				body.set_is_warping(false)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass