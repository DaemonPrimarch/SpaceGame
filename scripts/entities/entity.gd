tool

extends "res://scripts/extended_kinematic_body_2D.gd"

signal HP_changed
signal room_entered

signal state_entered(state, previous_state)
signal state_processed(state, delta)
signal state_left(state, new_state)
signal invulnerable_started()
signal invulnerable_stopped()

export var HP = 100 setget set_HP, get_HP
export var max_HP = 100 setget set_max_HP, get_max_HP

export var movement_speed = 64 * 5.12 setget set_movement_speed, get_movement_speed

export(NodePath) var debug_state_label
export(NodePath) var debug_grounded_label

export var gravity_enabled = false setget set_gravity_enabled, is_gravity_enabled
export var gravity_vector = Vector2(0, 64 * 18)

export var flippedH = false setget set_flippedH, is_flippedH
export var flippedV = false setget set_flippedV, is_flippedV

export var invulnerability_time = 1.0 setget set_invulnerability_time, get_invulnerability_time
var invulnerability_timer
var mask_save
var invulnerable = false

var grounded = false

var gravity_velocity = Vector2()
var gravity_timer = 0

var STATES = {"UNDEFINED": "UNDEFINED"}

var valid_states = ["UNDEFINED"]

var current_state = "UNDEFINED"

func _ready():
	set_physics_process(not Engine.is_editor_hint())
		
	if(not Engine.is_editor_hint()):
		get_node("/root/GUI").add_HP_bar(self)
		connect("room_entered", self, "_room_enter")
	
	invulnerability_timer = Timer.new()
	
	invulnerability_timer.set_name("invulnerable_timer")
	
	invulnerability_timer.connect("timeout",self,"_on_invulnerability_timer_timeout") 
	add_child(invulnerability_timer)

func _room_enter():
	get_node("/root/GUI").add_HP_bar(self)

func get_movement_speed():
	return movement_speed

func set_movement_speed(speed):
	movement_speed = speed
	
func _physics_process(delta):
	if(is_gravity_enabled()):
		if(is_grounded()):
			if(test_move(get_global_transform(), gravity_vector.normalized() * 0.1)):
				pass
			elif(test_move(get_global_transform(), gravity_vector.normalized() * delta * (Vector2(get_movement_speed(), 0)).rotated(max_slope_angle))):
				move_and_collide(gravity_vector.normalized() * delta * (Vector2(get_movement_speed(), 0)).rotated(max_slope_angle))
			else:
				set_grounded(false)
		else:
			apply_gravity(delta)
	
	emit_signal("state_processed", current_state, delta)
	
func push(vector):
	if(move_and_collide(vector) != null):
		crush() 

func crush():
	print("CRUSHED!")
	
func get_HP():
	return HP

func set_HP(hp):
	HP = hp
	
	emit_signal("HP_changed")
	
	if(hp <= 0):
		destroy()
	
func get_max_HP():
	return max_HP

func set_max_HP(max_hp):
	max_HP = max_hp

func damage(d):
	set_HP(get_HP() - d)
	invulnerability_timer.start()
	set_invulnerable(true)

func set_invulnerability_time(value):
	invulnerability_time = value

func get_invulnerability_time():
	return invulnerability_time

func _on_invulnerability_timer_timeout():
	set_invulnerable(false)
	invulnerability_timer.stop()

func is_invulnerable():
	return invulnerable

func set_invulnerable(value):
	invulnerable = value
	if(value):
		if(has_node("debug_invulnerable_label")):
			get_node("debug_invulnerable_label").text = "INVULNERABLE"
		
		mask_save = collision_mask
		collision_mask = 0
		set_collision_mask_bit(0,1)
		
		emit_signal("invulnerable_started")
	else:
		collision_mask = mask_save
		
		if(has_node("debug_invulnerable_label")):
			get_node("debug_invulnerable_label").text = ""
		
		emit_signal("invulnerable_stopped")

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

func is_grounded():
	return grounded
	
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
		emit_signal("state_left", current_state, state)
		emit_signal("state_entered", state, current_state)
		current_state = state
		
		if(has_debug_state_label()):
			get_node(get_debug_state_label()).set_text(state)

func add_state(state):
	if(is_valid_state(state)):
		print("ERROR, entity already has state: ", state)
	else:
		valid_states.push_back(state)

func is_flippedH():
	return flippedH

func is_flippedV():
	return flippedV

func is_valid_state(state):
	return valid_states.has(state)

func set_flippedH(val):
	if(val != is_flippedH()):
		for child in get_children():
			if(child is Node2D):
				child.set_scale(child.get_scale() * Vector2(-1,1))
				child.set_position(child.get_position() * Vector2(-1,1))
				child.set_rotation(-child.get_rotation())
	
	flippedH = val

func set_flippedV(val):
	if(val != is_flippedV()):
		for child in get_children():
			if(child is Node2D):
				child.set_scale(child.get_scale() * Vector2(1,-1))
				child.set_position(child.get_position() * Vector2(1,-1))
	
	flippedV = val

func get_direction():
	var dir = Vector2(1,1)
	
	if(is_flippedH()):
		dir.x = -1
	if(is_flippedV()):
		dir.y = -1
	
	return dir
	
func destroy():
	print("destrooooyy!!!!")
	queue_free()