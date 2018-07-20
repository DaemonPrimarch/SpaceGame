tool
extends "platform.gd"

var connected_nodes = []

func connect_node(node):
	connected_nodes.append(node)
	node.platform_manager.set_platform(self)

func disconnect_node(node):
	connected_nodes.remove(connected_nodes.find(node))
	node.platform_manager.set_platform(null)
	
func is_node_connected(node):
	return connected_nodes.find(node) != -1

func _physics_process(delta):
	for node in $Area2D.get_overlapping_bodies():
		if(node.is_in_group("handles_platform") and node.is_grounded() and not is_node_connected(node)):
			connect_node(node)
	
	for node in connected_nodes:
		if(not $Area2D.overlaps_body(node)):
			disconnect_node(node)

func move_and_push(v):
	for node in connected_nodes:
		node.position += v

	.move_and_push(v * Vector2(1,1))

func extend(v):
	for node in connected_nodes:
		if(not (is_extending_vertical() and v > 0)):
			node.position += (v * get_extending_direction())
		else:
			node.move_and_push(v * get_extending_direction())
		
	.extend(v)
	
	if(not is_extending_vertical()):
		$Area2D/CollisionPolygon2D.polygon[2].x += v
		$Area2D/CollisionPolygon2D.polygon[3].x += v
	else:
		$Area2D/CollisionPolygon2D.position.y -= v