extends Node2D

# class member variables go here, for example:
export var speed = 60*4
export var moving_to_first = true

onready var platform = get_node("platform")
onready var first_point = get_node("first_point")
onready var second_point = get_node("second_point")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	#connect("body_enter", get_node("platform/Area2D"), "on_body_enter")

func is_going_to_first():
	return moving_to_first

func get_speed():
	return speed

func _fixed_process(delta):
	var direction = (first_point.get_pos() - second_point.get_pos()).normalized()
	
	var projected_position_first = direction.dot(first_point.get_pos())
	var projected_position_second = direction.dot(second_point.get_pos())
	var projected_position_platform = direction.dot(platform.get_pos())
	
	if(is_going_to_first()):
		platform.move(direction*get_speed()*delta)
		if(projected_position_platform >= projected_position_first):
			moving_to_first = false
	else:
		platform.move(direction*get_speed()*delta*-1)
		if(projected_position_platform <= projected_position_second):
			moving_to_first = true

