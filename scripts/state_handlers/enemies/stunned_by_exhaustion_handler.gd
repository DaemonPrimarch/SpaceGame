extends "res://scripts/state_handler.gd"

func get_handled_state():
	return "STUNNED_BY_EXHAUSTION"
	
func enter_state(previous_state):
	.enter_state(previous_state)
	get_parent().get_node("eye_white").set("modulate", Color(0,0,0))
	
func leave_state(new_state):
	.leave_state(new_state)
	
func process_state(delta):
	.process_state(delta)
	
	if(get_timer() > get_parent().get_stunned_time_exhausted()):
		get_parent().set_flippedH(not get_parent().is_flippedH())
		get_parent().set_state("IDLE")