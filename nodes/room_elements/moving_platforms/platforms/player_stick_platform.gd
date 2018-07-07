extends "res://scripts/room_elements/moving_platforms/platforms/platform.gd"

var connected_nodes = []

func connect_node(node):
	connected_nodes.append(node)
	node.platform_manager.set_platform(self)

func disconnect_node(node):
	connected_nodes.remove(connected_nodes.find(node))
	node.platform_manager.set_platform(null)
	
func is_connected(node):
	connected_nodes.find(node) != -1

func _physics_process(delta):
	for node in $Area2D.get_overlapping_bodies():
		if(node.is_in_group("handles_platform") and node.is_grounded() and not is_connected(node)):
			connect_node(node)
	
	for node in connected_nodes:
		if($Area2D.overlaps_body(node)):
			disconnect_node(node)

func move_and_push(v):
	.move_and_push(v * Vector2(1,0))
	
	for node in connected_nodes:
		node.position += v
	
	.move_and_push(v * Vector2(0,1))
	