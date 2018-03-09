extends Node

export var enabled = true

func is_enabled():
	return enabled

var state_type = "UNDEFINED"

var no_gravity = false
var previous_gravity_enabled

var timer = 0

func _ready():
	get_parent().add_handler(self)
	
func can_enter():
	return is_enabled()

func _on_state_enter(state, previous_state):
	if(state == get_handled_state()):
		enter_state(previous_state)

func _on_state_process(state, delta):
	if(state == get_handled_state()):
		process_state(delta)

func _on_state_leave(state, new_state):
	if(state == get_handled_state()):
		leave_state(new_state)

func get_timer():
	return timer
	
func reset_timer():
	timer = 0
	
func get_handled_state():
	return state_type

func process_state(delta):
	timer += delta
	if(get_parent().can_be_pushed and get_parent().is_pushed):
		print("PUSH!")
		get_parent().set_state("PUSHED")
	
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