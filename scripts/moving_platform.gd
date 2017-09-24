extends Node2D

# class member variables go here, for example:
export var speed = 60
export var moving_to_first = true setget set_going_to_first, is_going_to_first

onready var platform = get_node("platform")
onready var first_point = get_node("first_point")
onready var second_point = get_node("second_point")

var direction
var objects_on_platform = {}

func _ready():
	# Called every time the node is added to the scene.
	direction = (first_point.get_pos() - second_point.get_pos()).normalized()
	set_fixed_process(true)

func set_going_to_first(val):
	moving_to_first = val

func is_going_to_first():
	return moving_to_first

func set_object_on_platform(obj, val):
	if(val):
		objects_on_platform[obj] = true
		obj.set_pos(Vector2(floor(obj.get_pos().x), floor(obj.get_pos().y + 1)))
	else:
		objects_on_platform.erase(obj)
		
func is_on_platform(obj):
	return objects_on_platform.has(obj)

func get_speed():
	return speed

func _fixed_process(delta):
	
	var projected_position_first = direction.dot(first_point.get_pos())
	var projected_position_second = direction.dot(second_point.get_pos())
	var projected_position_platform = direction.dot(platform.get_pos())
	
	
	var dir = 1
	if(is_going_to_first()):
		dir = 1
	else:
		dir = -1
	
	var first
	var second = Vector2()
	var finalA
	
	for obj in objects_on_platform:
		#obj.set_gravity_enabled(false)
		first = obj.get_pos()
		if(obj.move_no_collision(direction*get_speed()*dir*delta)):
			print("COLLISION!")
		second = obj.get_pos()
		
	
	platform.move_no_collision(direction*get_speed()*dir*delta)
	
	print(second - platform.get_pos())
	if(is_going_to_first() and projected_position_platform >= projected_position_first):
		set_going_to_first(false)
	elif(projected_position_platform <= projected_position_second):
		set_going_to_first(true)
		
func _on_Area2D_body_enter( body ):
	if(body.is_in_group("player")):
		print("added")
		#platform.add_collision_exception_with(body)
		set_object_on_platform(body, true)
		
func _on_Area2D_body_exit( body ):
	if(body.is_in_group("player")):
		print("released")
		set_object_on_platform(body, false)
		#platform.remove_collision_exception_with(body)