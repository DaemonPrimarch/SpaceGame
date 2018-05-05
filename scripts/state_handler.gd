extends Node

export var handled_state = "UNDEFINED"
export var enabled = true setget set_enabled, is_enabled

signal enabled
signal disabled

func is_enabled():
	return enabled
	
func set_enabled(val):
	enabled = val

	if(val):
		call_deferred("emit_signal", "enabled")
	else:
		call_deferred("emit_signal", "disabled")
	
var no_gravity = false
var previous_gravity_enabled

var timer = 0

func process_state(delta):
	timer += delta

func _ready():
	get_parent().add_handler(self)
	
func can_enter():
	return is_enabled()

func get_timer():
	return timer
	
func reset_timer():
	timer = 0
	
func get_handled_state():
	return handled_state
	
func enter_state(previous_state):
	reset_timer()
	
	if(has_no_gravity()):
		previous_gravity_enabled = get_parent().is_gravity_enabled()
		get_parent().set_gravity_enabled(false)

func leave_state(new_state):
	if(has_no_gravity()):
		get_parent().set_gravity_enabled(previous_gravity_enabled)
		
func set_no_gravity(val):
	no_gravity = val

func has_no_gravity():
	return no_gravity