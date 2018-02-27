extends Node2D

export var active = true
export var forward_starting_velocity = 0
export var forward_acceleration = 0

export var backward_starting_velocity = 0
export var backward_acceleration = 0

onready var start_position = get_node("start").get_position()
onready var end_position = get_node("stop").get_position()
onready var platform = get_node("platform")

var forward_velocity = forward_starting_velocity
var backward_velocity = backward_starting_velocity

var moving_forward = true

func set_active(value):
	active = value

func is_active():
	return active

func get_platform():
	return platform

func get_movement_direction():
	return (end_position - start_position).normalized()

func _process(delta):
	if(is_active()):
		if(moving_forward):
			get_platform().move_and_push(get_movement_direction() * forward_velocity * delta)
			
			forward_velocity += forward_acceleration * delta
	
			
			if((end_position - get_platform().get_position()).normalized().dot((end_position - start_position).normalized()) <= 0):
				moving_forward = false
				
				forward_velocity = forward_starting_velocity
		else:
			get_platform().move_and_push(get_movement_direction() * backward_velocity * delta * -1)
			
			backward_velocity += backward_acceleration * delta
		
			if((start_position - get_platform().get_position()).normalized().dot((start_position - end_position).normalized()) <= 0):
				moving_forward = true
				
				backward_velocity = backward_starting_velocity

func area_enter_trigger( body , val ):
	set_active(val)
