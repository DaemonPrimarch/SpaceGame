extends "res://scripts/extended_kinematic_body_2D.gd"

var connected_nodes = []

onready var standing_area = get_node("standing_area")

func connect_node(node):
	if(not connected_nodes.has(node)):
		connected_nodes.push_back(node)
		node.set_on_platform(true)
		node.add_collision_exception_with(self)

func disconnect_node(node):
	if(connected_nodes.has(node)):
		connected_nodes.remove(connected_nodes.find(node))
		node.set_on_platform(false)
		node.remove_collision_exception_with(self)

func _on_platform_collided(info, moved_node):
	if((moved_node == self and info.normal == Vector2(0,1))):
		connect_node(info.collider)
	if((not moved_node == self and info.normal == Vector2(0,-1))):
		connect_node(moved_node)
		
func _on_standing_area_body_exited( body ):
	disconnect_node(body)

func move_and_push(v):
	for node in connected_nodes:
		node.translate(v)
	
	var collision_info = move_and_collide(v)
		
	if(collision_info != null):
		if(collision_info.collider.has_method('push')):
			collision_info.collider.push(collision_info.remainder)
			
		translate(collision_info.remainder)
		