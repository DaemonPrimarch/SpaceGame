extends Node2D

# class member variables go here, for example:
export var speed = 60
export var moving_to_first = true

onready var platform = get_node("platform")
onready var first_point = get_node("first_point")
onready var second_point = get_node("second_point")

var room
var direction
var enter = false
var player

func _ready():
	# Called every time the node is added to the scene.
	direction = (first_point.get_pos() - second_point.get_pos()).normalized()
	set_fixed_process(true)

func is_going_to_first():
	return moving_to_first

func get_speed():
	return speed

func _fixed_process(delta):
	
	var projected_position_first = direction.dot(first_point.get_pos())
	var projected_position_second = direction.dot(second_point.get_pos())
	var projected_position_platform = direction.dot(platform.get_pos())
	
	if(is_going_to_first()):
		platform.move(direction*get_speed()*delta)
		if(enter == true):
			player.move((direction*get_speed()*delta))
		if(projected_position_platform >= projected_position_first):
			moving_to_first = false
	else:
		platform.move(direction*get_speed()*-1*delta)
		if(enter == true):
			player.move((direction*get_speed()*delta*-1))
		if(projected_position_platform <= projected_position_second):
			moving_to_first = true
	




func _on_Area2D_body_enter( body ):
	print("flap")
	if(body.is_in_group("player")):
		enter = true
		player = body
		
		#print("player")
		#room = body.get_parent()
		#body.set_pos(body.get_pos() - platform.get_pos())
		#room.remove_child(body)
		#platform.add_child(body)

func _on_Area2D_body_exit( body ):
	if(body.is_in_group("player")):
		enter = false
#	print("flop")
#	if(body.is_in_group("player")):
#		#body.set_pos(platform.get_pos() - body.get_pos())
#		#platform.remove_child(body)
#		room.add_child(body)