tool

extends "res://scripts/extended_kinematic_body_2D.gd"

signal room_entered

signal state_entered(state, previous_state)
signal state_left(state, new_state)

export var movement_speed = 64 * 5.12 setget set_movement_speed, get_movement_speed

export(NodePath) var debug_state_label
export(NodePath) var debug_grounded_label

export var gravity_enabled = false setget set_gravity_enabled, is_gravity_enabled
export var gravity_vector = Vector2(0, 64 * 18)

export var can_be_pushed = false
var is_pushed = false
var push_direction

var grounded = false

var gravity_velocity = Vector2()
var gravity_timer = 0

var valid_states = ["UNDEFINED"]

var state_handlers = {}

var current_state = "UNDEFINED"

var platform = null

func set_platform(plat):
	platform = plat
	
	if(plat):
		set_grounded(true)
		print(is_grounded())

func is_grounded():
	return grounded

func is_on_platform():
	return platform != null

func get_platform():
	return platform

func _ready():
	set_physics_process(not Engine.is_editor_hint())

func get_movement_speed():
	return movement_speed

func set_movement_speed(speed):
	movement_speed = speed
	
func _physics_process(delta):
	if(is_gravity_enabled()):
		if(is_grounded()):
			if(not is_on_platform()):
				if(test_move(get_global_transform(), gravity_vector.normalized() * 0.1)):
					pass
				elif(test_move(get_global_transform(), gravity_vector.normalized() * delta * (Vector2(get_movement_speed(), 0)).rotated(max_slope_angle))):
					move_and_collide(gravity_vector.normalized() * delta * (Vector2(get_movement_speed(), 0)).rotated(max_slope_angle))
				else:
					set_grounded(false)
		else:
			apply_gravity(delta)
	
	if(has_handler(get_state())):
		get_handler(get_state()).process_state(delta)
	
func push(vector):
	if(move_and_collide(vector) != null):
		crush() 

func crush():
	print("CRUSHED!")

func add_handler(handler):
	var handled_state = handler.get_handled_state()
	
	if(is_valid_state(handled_state)):
		state_handlers[handled_state] = handler
	else:
		print("ERROR Not valid state")
	
func has_handler(state):
	return state_handlers.has(state)
		
func get_handler(state):
	if(is_valid_state(state)):
		if(has_handler(state)):
			return state_handlers[state]
		else:
			print("ERROR: Handler for state ", state, " not found")
	else:
		print("ERROR: ", state, " not legal state.")

func is_gravity_enabled():
	return gravity_enabled

func set_gravity_enabled(value, starting_velocity = Vector2()):
	gravity_enabled = value
	
	gravity_velocity = starting_velocity
	
func get_gravity_vector():
	return gravity_vector

func apply_gravity(delta):
	gravity_velocity += get_gravity_vector() * delta
	
	var collision_info = move_and_collide(gravity_velocity * delta)
	
	if(collision_info != null):
		set_grounded(true)

func has_debug_grounded_label():
	return debug_grounded_label != null and debug_grounded_label != ""

func get_debug_grounded_label():
	return get_node(debug_grounded_label)

func has_debug_state_label():
	return debug_state_label != null and debug_state_label != ""

func get_debug_state_label():
	return debug_state_label
	
func set_grounded(val):
	grounded = val
	
	gravity_velocity = Vector2()
	
	if(has_debug_grounded_label()):
		if(val):
			get_debug_grounded_label().set_text("G")
		else:
			get_debug_grounded_label().set_text("N")
		

func get_state():
	return current_state
	
func set_state(state):
	if(not is_valid_state(state)):
		print("ERROR, entity doesn't have state: ", state)
	else:
		var old_state = get_state()
		
		if(has_handler(get_state())):
			get_handler(get_state()).leave_state(state)
		
		emit_signal("state_left", get_state(), state)
		
		if(has_handler(state)):
			get_handler(state).enter_state(old_state)
		
		emit_signal("state_entered", state, old_state)
		current_state = state
		
		if(has_debug_state_label()):
			get_node(get_debug_state_label()).set_text(state)

func add_state(state):
	if(is_valid_state(state)):
		print("ERROR, entity already has state: ", state)
	else:
		valid_states.push_back(state)


func is_valid_state(state):
	return valid_states.has(state)

	
func destroy():
	queue_free()
	
func damage_push(object):
	if(can_be_pushed):
		var direction
		if(object.position.x > position.x):
			direction = -1
		else:
			direction = 1
		push_direction = direction
		is_pushed = true