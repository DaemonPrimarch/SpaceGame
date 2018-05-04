extends Node2D

export var active = true
export var looping = false
export var one_way = false
export var moving_speed = 64 * 3
export var snap = false
export var step = false
export var timed = false
export var start_at = 0

var next_point_counter = 1
var next_point = Vector2()
var previous_point = Vector2()
var arrived = false
var direction = 1

var current_point = 0
signal platform_loaded
signal arrived_at_next_point(point)
var platform = null

func get_movement_speed():
	return moving_speed

func is_one_way():
	return one_way

func has_arrived_at_end():
	return arrived

func is_moving():
	return is_active()

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
	for child in get_children():
		if(child.is_in_group("platform")):
			platform = child
	
	emit_signal("platform_loaded")
			
	set_next_point(get_node("point_1").get_position())
	set_previous_point(get_node("point_0").get_position())
	
	get_platform().position = get_node("point_0").position
	
	connect("arrived_at_next_point",self,"one_way_stop")
	
	if(start_at != 0):
		get_platform().move_and_push(get_node("point_" + String(start_at)).get_position() - get_node("point_" + String(0)).get_position())
		current_point = start_at
		
		if(has_node("point_" + String(start_at + 1))):
			next_point_counter = start_at + 1
			set_next_point(get_node("point_" + String(next_point_counter)).get_position())
		elif(is_looping()):
			next_point_counter = 0
			
			set_next_point(get_node("point_" + String(next_point_counter)).get_position())
		else:
			direction = -direction
			next_point_counter = start_at + direction
			set_next_point(get_node("point_" + String(next_point_counter)).get_position())
		
	if(not active):
		arrived = true
	
	
func _physics_process(delta):
	if(is_active()):
		get_platform().move_and_push(get_movement_direction() * delta * get_movement_speed())
		
		if(has_arrived_at_next_point()):
			if(timed):
				get_node("Timer").start()
			current_point = next_point_counter
			if(is_one_way()):
				get_platform().position = get_next_point()
				
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
					
			emit_signal("arrived_at_next_point", get_next_point())
			
			if(step):
				set_active(false)
				arrived = true

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
	set_previous_point(get_next_point())
				
	next_point_counter += direction
	direction = -direction
		
	next_point_counter += 2*direction
	
	set_next_point(get_node("point_" + String(next_point_counter)).get_position())

func switch(counter):

	if(current_point == counter):
		next_point_counter = counter + 1
	elif(current_point == counter + 1):
		next_point_counter = counter
		counter += 1
	else:
		return

	set_active(true)
	arrived = false
	set_previous_point(get_node("point_" + String(counter)).get_position())
			
	if(has_node("point_" + String(next_point_counter))):
		set_next_point(get_node("point_" + String(next_point_counter)).get_position())
	else:
		print("no such node found")

func go_to(point):
	get_node("Timer").stop()
	set_active(true)
	arrived = false
	if(point == 0):
		var i = 1
		while(has_node("point_" + String(i))):
				i += 1
		set_previous_point(get_node("point_" + String(i-1)).get_position())
		current_point = i-1
	else:
		set_previous_point(get_node("point_" + String(0)).get_position())
		current_point = 0
			
	if(has_node("point_" + String(point))):
		set_next_point(get_node("point_" + String(point)).get_position())
	else:
		print("no such node found")
		
