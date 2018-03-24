extends "res://scripts/platform.gd"

signal stepped_on(node)
signal stepped_off(node)

var connected_nodes = []

onready var standing_area = get_node("standing_area")

var still_on = false

func _ready():
	get_node("left_detector").add_exception(get_node("standing_area"))
	get_node("right_detector").add_exception(get_node("standing_area"))

func _physics_process(delta):
	get_node("left_detector").force_raycast_update()
	get_node("right_detector").force_raycast_update()
	
	if(not still_on and get_node("left_detector").is_colliding() and not connected_nodes.has(get_node("left_detector").get_collider()) and get_node("left_detector").get_collider().has_method("set_platform")):
		connect_node(get_node("left_detector").get_collider())
	
	if(not still_on and get_node("right_detector").is_colliding() and not connected_nodes.has(get_node("right_detector").get_collider()) and get_node("right_detector").get_collider().has_method("set_platform")):
		connect_node(get_node("right_detector").get_collider())

func connect_node(node):
	if(not connected_nodes.has(node)):
		still_on = true
		
		connected_nodes.push_back(node)
		if(node.is_on_platform()):
			node.get_platform().disconnect_node(node)
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
	still_on = false
	
	call_deferred("disconnect_node",body)

func move_and_push(v):
	for node in connected_nodes:
		node.push(Vector2(0,v.y))
		node.move_and_collide(Vector2(v.x, 0))
	
	.move_and_push(v)

func extend(v):
	.extend(v)
	
	var standing_polygon = get_node("standing_area/CollisionPolygon2D").polygon
	if(v.x != 0):
		if(is_flippedH()):
			get_node("right_detector").position -= Vector2(v.x,0)
			standing_polygon[2] -= Vector2(v.x,0)
			standing_polygon[3] -= Vector2(v.x,0)
		else:
			get_node("left_detector").position -= Vector2(v.x,0)
			standing_polygon[0] -= Vector2(v.x,0)
			standing_polygon[1] -= Vector2(v.x,0)
			
	get_node("standing_area/CollisionPolygon2D").polygon = standing_polygon
	
func snap_to(node):
	pass