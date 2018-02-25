extends "res://scripts/state_handler.gd"

func get_handled_state():
	return "IDLE"
	
func enter_state(previous_state):
	.enter_state(previous_state)
	
func leave_state(new_state):
	.leave_state(new_state)
	
func process_state(delta):
	.process_state(delta)
	
	if(get_parent().get_player_detector().is_colliding()):
		var collider = get_parent().get_player_detector().get_collider()
		if(collider.is_in_group("player")):
			get_parent().set_state(get_parent().STATES.CHARGING)
