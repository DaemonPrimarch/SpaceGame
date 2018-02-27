extends "res://scripts/state_handler.gd"

func get_handled_state():
	return "CROUCHING"

func enter_state(previous_state):
	.enter_state(previous_state)
	
	get_parent().set_scale(get_parent().get_scale() * Vector2(1,0.5))
	
func leave_state(new_state):
	.leave_state(new_state)
	
	get_parent().set_scale(get_parent().get_scale() * Vector2(1,2))
	
func process_state(delta):
	.process_state(delta)
	
	if(not Input.is_action_pressed("play_down")):
		get_parent().set_state("STANDING")
	else:
		if(Input.is_action_pressed("play_left")):
			get_parent().set_flippedH(true)
		elif(Input.is_action_pressed("play_right")):
			get_parent().set_flippedH(false)