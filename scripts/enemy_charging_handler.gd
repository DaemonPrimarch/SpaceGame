extends "res://scripts/state_handler.gd"

func get_handled_state():
	return "CHARGING"
	
func enter_state(previous_state):
	.enter_state(previous_state)
	
func leave_state(new_state):
	.leave_state(new_state)
	
func process_state(delta):
	.process_state(delta)
	if(get_timer() < 3):
		var collider = get_parent().move_and_collide_slope(get_parent().get_direction() * Vector2(1,0) * delta * get_parent().get_charging_speed())
		if(collider != null):
			get_parent().set_state(get_parent().STATES.STUNNED)
		else if(get_parent().get_ground_detector().has_collider() == null):
			pass
