tool

extends Node2D

var platform = null

signal arrived_at_start()
signal arrived_at_distance()
signal arrived_at_end()
signal platform_loaded()

signal activated()
signal deactivated()

func get_platform():
	return platform

func init_platform():
	for node in get_children():
		if(node.is_in_group("platform")):
			platform = node
	
	if(has_platform()):
		get_platform().position = Vector2()
		
		get_platform().set_meta("_edit_lock_", true)
		
		get_platform().connect("flippedH", self, "update")
		
		emit_signal("platform_loaded")
		
		get_platform().position = Vector2()

func add_child(node):
	.add_child(node)
	
	if(not has_platform()):
		init_platform()

func _ready():
	init_platform()
	
	set_physics_process(not Engine.editor_hint)
	
	forward_velocity = forward_starting_velocity
	backward_velocity = backward_starting_velocity
	
	if(extending_distances == null):
		extending_distances = [0, 64]
	
	next_distance_index = 0
	set_next_extending_distance(1)
	
	set_active(is_active())
	
	if(is_active()):
		emit_signal("activated")
		
func has_platform():
	return platform != null

func _draw():
	if(has_platform() and is_inside_tree()):
		var large_dist = -10000
		var small_dist = 10000
		
		for i in extending_distances:
			large_dist = max(large_dist, i)
			small_dist = min(small_dist, i)
			draw_circle(get_platform().get_direction() * get_extending_orientation() * i *  Vector2(1,-1) + get_platform().get_direction() * get_extending_orientation() * Vector2(32,32) *  Vector2(1,-1) , 4, Color(1,0, 0))
		
		draw_line(get_platform().get_direction() * get_extending_orientation() * (small_dist + 32), get_extending_orientation() * get_platform().get_direction() * (large_dist + 32) * Vector2(1,-1) ,ProjectSettings.get_setting("debug/shapes/collision/shape_color"), 4.0)
export var active = true

export var one_shot = false

export var extending_vertical = true setget set_extending_vertical
func set_extending_distances(val):
	extending_distances = val

	update()
	
func set_extending_vertical(val):
	extending_vertical = val
	
	update()

func turn_around():
	set_next_extending_distance(prev_distance_index)

func is_extending_vertical():
	return extending_vertical

export(Array, int) var extending_distances setget set_extending_distances

export var forward_starting_velocity = 64*5
export var forward_acceleration = 64*3

export var backward_starting_velocity = 64
export var backward_acceleration = 64

var forward_velocity = 0
var backward_velocity = 0

var advancing = true

var waiting = false

func set_waiting(val):
	waiting = val

func is_waiting():
	return waiting

func set_active(value):
	if(is_inside_tree() and value != is_active()):
		if(value):
			emit_signal("activated")
		else:
			emit_signal("deactivated")
	
	active = value
	
func is_active():
	return active
	
func set_next_extending_distance(index):
	prev_distance_index = next_distance_index
	
	next_distance_index = index

func get_next_extending_distance():
	return extending_distances[next_distance_index]

func get_extending_orientation():
	if(is_extending_vertical()):
		return Vector2(0, 1)
	else:
		return Vector2(1, 0)

func get_next_extending_direction():
	var dir = get_next_extending_distance() - get_previous_extending_distance()
	
	dir /= abs(dir)
	
	return dir

var pos = 0

func reset_velocities():
	forward_velocity = forward_starting_velocity
	backward_velocity = backward_starting_velocity

var prev_distance_index = 0
var next_distance_index = 0

func get_previous_extending_distance():
	return extending_distances[prev_distance_index] 

func has_arrived_at_next_extending_distance():
	return ((pos) * get_next_extending_direction() > get_next_extending_direction() * get_next_extending_distance())

func advance_next_extending_distance():
	if(next_distance_index == extending_distances.size() - 1):
		advancing = false
		
		emit_signal("arrived_at_end")
	elif(next_distance_index == 0):
		advancing = true
		
		if(one_shot):
			set_active(false)
		
		emit_signal("arrived_at_start")
		
	var dir = 1
		
	if(not advancing):
		dir = -1
	
	emit_signal("arrived_at_distance", next_distance_index)
	
	set_next_extending_distance(next_distance_index + dir)

func _physics_process(delta):
	if(is_active() and has_platform() and not is_waiting()):
		if(get_next_extending_direction() > 0):
			get_platform().extend(get_extending_orientation() * get_next_extending_direction() * forward_velocity * delta)
			
			pos += get_next_extending_direction() * forward_velocity * delta

			forward_velocity += forward_acceleration * delta
	
		else:
			get_platform().extend(get_extending_orientation() * get_next_extending_direction() * backward_velocity * delta)
			
			pos += get_next_extending_direction() * backward_velocity * delta
			
			backward_velocity += backward_acceleration * delta
	
		if(has_arrived_at_next_extending_distance()):
			#pos = get_next_extending_distance()
			
			advance_next_extending_distance()
			
			reset_velocities()