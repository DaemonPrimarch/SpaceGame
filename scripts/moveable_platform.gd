extends Node2D

export var active = true
export var looping = false
export var one_way = false
export var moving_speed = 64 * 4

var next_point_counter = 1
var next_point = Vector2()
var previous_point = Vector2()
var arrived = false
var direction = 1

var connected_nodes = []

onready var platform = get_node("platform")
onready var standing_area = get_node("platform/standing_area")

func get_movement_speed():
	return moving_speed

func is_one_way():
	return one_way

func has_arrived_at_end():
	return arrived

func get_platform():
	return platform

func set_next_point(point):
	next_point = point

func set_previous_point(point):
	previous_point = point
	
func get_next_point():
	return next_point

func get_previous_point():
	return previous_point

func get_movement_direction():
	return (get_next_point() - get_platform().get_position()).normalized()

func has_arrived_at_next_point():
	return ((get_next_point() - get_previous_point()).dot(get_movement_direction()) <= 0)

func _ready():
	get_platform().set_position(get_node("point_0").get_position())
	set_next_point(get_node("point_1").get_position())
	set_previous_point(get_node("point_0").get_position())
	
func _physics_process(delta):
	if(is_active() and not (is_one_way() and has_arrived_at_end())):
		
		for node in connected_nodes:
			node.translate(get_movement_direction() * delta * get_movement_speed())
	
		var collision_info = platform.move_and_collide(get_movement_direction() * delta * get_movement_speed())
		
		if(collision_info != null):
			if(collision_info.collider.has_method('push')):
				collision_info.collider.push(collision_info.remainder)
			
			get_platform().translate(collision_info.remainder)
		
		if(has_arrived_at_next_point()):
			set_previous_point(get_next_point())
			
			next_point_counter += direction
			
			if(has_node("point_" + String(next_point_counter))):
				set_next_point(get_node("point_" + String(next_point_counter)).get_position())
			elif(is_one_way()):
				arrived = true
			elif(is_looping()):
				next_point_counter = 0
				
				set_next_point(get_node("point_" + String(next_point_counter)).get_position())
			else:
				direction = -direction
				
				next_point_counter += 2*direction
				
				set_next_point(get_node("point_" + String(next_point_counter)).get_position())

func set_active(value):
	active = value

func is_active():
	return active
	
func set_looping(value):
	looping = value

func is_looping():
	return looping

func connect_node(node):
	if(not connected_nodes.has(node)):
		connected_nodes.push_back(node)
		node.set_on_platform(true)
		node.add_collision_exception_with(get_platform())

func disconnect_node(node):
	if(connected_nodes.has(node)):
		connected_nodes.remove(connected_nodes.find(node))
		node.set_on_platform(false)
		node.remove_collision_exception_with(get_platform())

func _on_platform_collided(info, moved_node):
	if((moved_node == get_platform() and info.normal == Vector2(0,1))):
		connect_node(info.collider)
	if((not moved_node == get_platform() and info.normal == Vector2(0,-1))):
		connect_node(moved_node)
		


func _on_standing_area_body_exited( body ):
	disconnect_node(body)
