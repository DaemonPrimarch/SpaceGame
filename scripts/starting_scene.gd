extends Node2D

var loaded = false
var first = true
export var destination_scene_path = "path"
export var arrival_node_ID = "arrival_name"

func on_enter(body):
	if(body.is_in_group("warpable") and not loaded):
		loaded = true
		body.set_is_warping(true)
		print(destination_scene_path)
		var loaded_scene = load(destination_scene_path).instance()
		var original_scene = self
		get_tree().get_root().add_child(loaded_scene)
		original_scene.remove_child(body)
		loaded_scene.add_child(body)
		original_scene.queue_free()
		var tree = loaded_scene.get_tree()
		for node in loaded_scene.get_tree().get_nodes_in_group("warp_arrival"):
			if(node.get_name() == arrival_node_ID):
				body.set_global_pos(node.get_global_pos())
				body.set_is_warping(false)

func _ready():
	set_process(true)

func _process(delta):
	if(first):
		var body = get_node("player")
		on_enter(body)
		first = false
