extends Node2D

export var active = true
export var looping = false
export var one_way = false
export var moving_speed = 64 * 3
export var snap = false

var next_point_counter = 1
var next_point = Vector2()
var previous_point = Vector2()
var arrived = false
var direction = 1

signal arrived_at_next_point(point)
onready var platform = get_node("platform")

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
	if(is_active() and snap):
		get_platform().set_position(get_node("point_0").get_position())
	set_next_point(get_node("point_1").get_position())
	set_previous_point(get_node("point_0").get_position())
	
	get_platform().position = get_node("point_0").position
	
	connect("arrived_at_next_point",self,"one_way_stop")
	
func _physics_process(delta):
	if(is_active()):
		get_platform().move_and_push(get_movement_direction() * delta * get_movement_speed())
		
		if(has_arrived_at_next_point()):
			if(is_one_way()):
				emit_signal("arrived_at_next_point", get_next_point())
			else:
				set_previous_point(get_next_point())
				
				next_point_counter += direction
				
				if(has_node("point_" + String(next_point_counter))):
					set_next_point(get_node("point_" + String(next_point_counter)).get_position())
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

func one_way_stop(point):
	set_active(false)
	arrived = true

func switch():
	set_active(true)
	arrived = false
	set_previous_point(get_next_point())
			
	next_point_counter += direction
	if(has_node("point_" + String(next_point_counter))):
		set_next_point(get_node("point_" + String(next_point_counter)).get_position())
	elif(is_looping()):
		next_point_counter = 0
		
		set_next_point(get_node("point_" + String(next_point_counter)).get_position())
	else:
		direction = -direction
		
		next_point_counter += 2*direction
		
		set_next_point(get_node("point_" + String(next_point_counter)).get_position())
