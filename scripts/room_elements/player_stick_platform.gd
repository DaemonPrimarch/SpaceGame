extends "res://scripts/extended_kinematic_body_2D.gd"

signal stepped_on(node)
signal stepped_off(node)

var connected_nodes = []

onready var standing_area = get_node("standing_area")

export var one_way = false

func _ready():
	get_node("left_detector").add_exception(get_node("standing_area"))
	get_node("right_detector").add_exception(get_node("standing_area"))

func _physics_process(delta):
	get_node("left_detector").force_raycast_update()
	get_node("right_detector").force_raycast_update()
	
	if(get_node("left_detector").is_colliding() and not connected_nodes.has(get_node("left_detector").get_collider()) and get_node("left_detector").get_collider().has_method("set_platform")):
		connect_node(get_node("left_detector").get_collider())
	
	if(get_node("right_detector").is_colliding() and not connected_nodes.has(get_node("right_detector").get_collider()) and get_node("right_detector").get_collider().has_method("set_platform")):
		connect_node(get_node("righ_detector").get_collider())

func is_one_way():
	return one_way

func connect_node(node):
	if(not connected_nodes.has(node)):
		connected_nodes.push_back(node)
		node.set_platform(self)
		node.add_collision_exception_with(self)
		
		emit_signal("stepped_on", node)

func disconnect_node(node):
	if(connected_nodes.has(node)):
		connected_nodes.remove(connected_nodes.find(node))
		node.set_platform(null)
		node.remove_collision_exception_with(self)
		
		emit_signal("stepped_off", node)

func _on_platform_collided(info, moved_node):
	if((moved_node == self and info.normal == Vector2(0,1))):
		connect_node(info.collider)
	if((not moved_node == self and info.normal == Vector2(0,-1))):
		connect_node(moved_node)
		
func _on_standing_area_body_exited( body ):
	call_deferred("disconnect_node",body)

func move_and_push(v):
	for node in connected_nodes:
		node.move_and_collide(v)
	
	.move_and_push(v)

func _on_standing_area_body_entered( body ):
	#HACK
	
	if(body.test_move(body.get_global_transform(),body.gravity_vector.normalized() * 0.1)):
		connect_node(body)
