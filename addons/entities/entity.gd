tool


extends "res://addons/extended_kinematic_body_2D/extended_kinematic_body_2D.gd"

signal room_entered()

signal state_entered(state, previous_state)
signal state_left(state, new_state)
signal crushed()
signal ground_entered()
signal ground_exited()

var valid_states = ["UNDEFINED"]

func is_valid_state(state):
	return valid_states.has(state)
	
func add_state(state):
	if(is_valid_state(state)):
		print("ERROR, entity already has state: ", state)
	else:
		valid_states.push_back(state)

var state_handlers = {}

export var current_state = "UNDEFINED" setget set_state

func get_state():
	return current_state
	
func set_state(state):
	if(is_inside_tree()):
		if(not is_valid_state(state)):
			print("ERROR, entity doesn't have state: ", state)
		else:
			var old_state = get_state()
			
			if(not first_state and has_handler(get_state())):
				get_handler(get_state()).leave_state(state)
			else:
				first_state = false
			
			emit_signal("state_left", get_state(), state)
			
			if(has_handler(state)):
				get_handler(state).enter_state(old_state)
			
			emit_signal("state_entered", state, old_state)
			current_state = state
	else:
		current_state = state

func can_enter_state(state):
	if(has_handler(state)):
		return get_handler(state).can_enter()
	else:
		return false

export var movement_speed = 64 * 5.12 setget set_movement_speed, get_movement_speed

func get_movement_speed():
	return movement_speed

func set_movement_speed(speed):
	movement_speed = speed
	
export var gravity_enabled = false setget set_gravity_enabled, is_gravity_enabled
export var gravity_vector = Vector2(0, 64 * 18)

func is_gravity_enabled():
	return gravity_enabled

func get_gravity_vector():
	return gravity_vector

func set_gravity_enabled(value, starting_velocity = Vector2()):
	gravity_enabled = value
	
	grounded = false
	
	#gravity_velocity = starting_velocity

export var velocity = Vector2() setget set_velocity

func get_velocity():
	return velocity

func set_velocity(v):
	var temp_velocity = v
	
	if(get_max_velocity().x >= 0 and v.x > get_max_velocity().x):
		temp_velocity.x = get_max_velocity().x
		print("Larger than max_velocity.x")
	if(get_max_velocity().y >= 0 and v.y > get_max_velocity().y):
		temp_velocity.y = get_max_velocity().y
		print("Larger than max_velocity.y")

	velocity = temp_velocity

export var max_velocity = Vector2(-1,-1) setget set_max_velocity

func set_max_velocity(v):
	max_velocity = v

	set_velocity(get_velocity())

func get_max_velocity():
	return max_velocity

export var acceleration = Vector2()

func get_acceleration():
	return acceleration

func set_acceleration(v):
	acceleration = v

export var can_be_pushed = false

var velocity_x_applied = false
var velocity_y_applied = false

func is_velocity_x_applied():
	return velocity_x_applied

func is_velocity_y_applied():
	return velocity_y_applied

func reset_velocities_applied_check():
	velocity_x_applied = false
	velocity_y_applied = false

func apply_velocity_x(delta):
	velocity_x_applied = true
	
	return move_and_collide(Vector2(1,0) * get_direction() * delta * get_velocity())
	
func apply_velocity_y(delta):
	velocity_y_applied = true
	
	return move_and_collide(Vector2(0,1) * get_direction() * delta * get_velocity())

func calculate_new_velocity(delta):
	set_velocity(get_velocity() +  get_acceleration() * delta)
	
	if(is_gravity_enabled() and not is_grounded()):	
		set_velocity(get_velocity() +  gravity_vector * delta)

var is_pushed = false
var push_direction

var grounded = false

func set_grounded(val):
	grounded = val
	
	if(val):
		emit_signal("ground_entered")
	else:
		emit_signal("ground_exited")

func is_grounded():
	return (grounded and is_gravity_enabled())


var inside_helper_areas = {}

func set_inside_helper_area(type, val):
	if(val):
		inside_helper_areas[type] = type
	else:
		inside_helper_areas.erase(type)
	
func is_inside_helper_area(type):
	return inside_helper_areas.has(type)

var first_state = true

var platform_manager = null

#
func _ready():
	if(Engine.is_editor_hint() and not has_node("platform_manager")):
		platform_manager = preload("res://nodes/managers/platform_manager.tscn").instance()
		
		add_child(platform_manager)
		
		platform_manager.set_owner(get_tree().get_edited_scene_root())
	else:
		platform_manager = get_node("platform_manager")
	

	
	add_to_group("entity")
	set_physics_process(not Engine.is_editor_hint())

	connect("collided", self, "check_if_ground_hit_on_collision")

	call_deferred("set_state",get_state())

func _physics_process(delta):
	if(has_handler(get_state())):
		get_handler(get_state()).process_state(delta)
	
	calculate_new_velocity(delta)
	
	if(not is_velocity_x_applied()):
		apply_velocity_x(delta)
	
	if(not is_velocity_y_applied()):
		apply_velocity_y(delta)
	
	reset_velocities_applied_check()
	
	if(is_gravity_enabled() and is_grounded()):
		check_if_still_on_ground(delta)
		
#GRAVITY FUNCTIONS
func check_if_ground_hit_on_collision(collision_info, bla):
	if(collision_info != null and collision_info.travel.y > 0):
		set_grounded(true)

func check_if_still_on_ground(delta):
	if(is_gravity_enabled()):
		if(test_move(transform, gravity_vector.normalized())):
			pass
		elif(test_move(get_global_transform(), gravity_vector.normalized() * delta * (Vector2(get_movement_speed(), 0)).rotated(max_slope_angle))):
			move_and_collide(gravity_vector.normalized() * delta * (Vector2(get_movement_speed(), 0)).rotated(max_slope_angle))
		else:
			set_grounded(false)

func push(vector):
	if(move_and_collide(vector) != null):
		crush() 

func crush():
	print("CRUSHED!")
	
	emit_signal("crushed")

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

func get_AABB():
	print("WHO USED get_AABB?")
	
	return AABB()