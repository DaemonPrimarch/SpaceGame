extends "res://scripts/state_handler.gd"

func get_handled_state():
	return "STUNNED"
	
func enter_state(previous_state):
	.enter_state(previous_state)
	
func leave_state(new_state):
	.leave_state(new_state)
	
func process_state(delta):
	.process_state(delta)
	
	if(get_timer() > get_parent().get_stunned_time()):
		get_parent().set_flippedH(not get_parent().is_flippedH())
		get_parent().set_state("IDLE")
