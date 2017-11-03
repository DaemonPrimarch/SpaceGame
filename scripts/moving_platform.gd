extends Node2D

export var speed = 60
export var active = true
export var stop_after_arrival = false
export var looping = false

onready var platform = get_node("platform")

var next_point_number = 2
var current_point
var next_point
var direction
var reversing = 1

var objects_on_platform = {}

func _ready():
	# Called every time the node is added to the scene.
	
	set_current_point(get_node(get_point_name(1)))
	set_next_point(get_node(get_point_name(2)))

	set_fixed_process(true)

func is_looping():
	return looping

func set_active(value):
	active = value
	
func is_active():
	return active
	
func stops_after_arrival():
	return stop_after_arrival

func set_current_point(point):
	current_point = point

func set_next_point(point):
	set_direction((point.get_pos() - get_current_point().get_pos()).normalized())
	next_point = point

func get_direction():
	return direction
	
func set_direction(new):
	direction = new
	
func get_current_point():
	return current_point

func get_next_point():
	return next_point

func get_point_name(number):
	return "point_" + str(number)

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
	if(is_active()):
		for obj in objects_on_platform:
			obj.move_no_collision(get_direction()*get_speed()*delta)
		
		platform.move_no_collision(get_direction()*get_speed()*delta)
		
		var projected_position_next = get_direction().dot(get_next_point().get_pos())
		var projected_position_platform = get_direction().dot(platform.get_pos())
		
	
		if(projected_position_platform >= projected_position_next):
			set_current_point(get_next_point())
			
			if(!has_node(get_point_name(next_point_number + reversing))):
				if(not stops_after_arrival()):
					if(is_looping()):
						next_point_number = 0
					else:
						reversing = -reversing
				else:
					reversing = 0
			next_point_number += reversing
			
			set_next_point(get_node(get_point_name(next_point_number)))
		
		
func _on_Area2D_body_enter( body ):
	if(body.is_in_group("player")):
		set_object_on_platform(body, true)
		
func _on_Area2D_body_exit( body ):
	if(body.is_in_group("player")):
		set_object_on_platform(body, false)