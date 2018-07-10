tool

extends Node2D

var platform = null
signal end_reached()
signal start_reached()
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

var first = false

func _ready():
	init_platform()
	
	set_physics_process(not Engine.editor_hint)
	
	forward_velocity = forward_starting_velocity
	backward_velocity = backward_starting_velocity
	
	set_active(is_active())
	
	if(is_active()):
		emit_signal("activated")
		
func has_platform():
	return platform != null

func _draw():
	if(has_platform() and is_inside_tree()):
		draw_line(Vector2(32,32) * get_platform().get_direction() * get_extending_direction(), get_extending_direction() * get_platform().get_direction() * (Vector2(side_extending_distance + 32, up_extending_distance + 32))  * Vector2(1,-1) ,ProjectSettings.get_setting("debug/shapes/collision/shape_color"), 4.0)

export var active = true

export var one_shot = false

export var side_extending_distance = 64 setget set_side_extending_distance
export var up_extending_distance = 0 setget set_up_extending_distance

func set_side_extending_distance(val):
	side_extending_distance = val
	
	update()

func set_up_extending_distance(val):
	up_extending_distance = val
	
	update()

export var forward_starting_velocity = 64*5
export var forward_acceleration = 64*3

export var backward_starting_velocity = 64
export var backward_acceleration = 64

var forward_velocity = forward_starting_velocity
var backward_velocity = backward_starting_velocity

var moving_forward = true

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

func get_extending_distance():
	return get_extending_direction() * Vector2(side_extending_distance, up_extending_distance)

func get_extending_direction():
	return Vector2(side_extending_distance, up_extending_distance)/Vector2(side_extending_distance, up_extending_distance).length()

var pos = Vector2()

func _physics_process(delta):
	if(is_active() and has_platform() and not is_waiting()):
		if(moving_forward):
			get_platform().extend(get_extending_direction() * forward_velocity * delta)
			pos += (get_extending_direction() * forward_velocity * delta)

			forward_velocity += forward_acceleration * delta
	
			if((get_extending_distance() - pos).normalized().dot(get_extending_direction()) <= 0):
				moving_forward = false
				
				forward_velocity = forward_starting_velocity
				
				emit_signal("end_reached")
		else:
			get_platform().extend(-get_extending_direction() * backward_velocity * delta)
			pos -= (get_extending_direction() * backward_velocity * delta)
			
			backward_velocity += backward_acceleration * delta

			if((get_extending_direction() - pos).normalized().dot(get_extending_direction()) >= 0):
				moving_forward = true

				backward_velocity = backward_starting_velocity

				emit_signal("start_reached")
				
				if(one_shot):
					set_active(false)
