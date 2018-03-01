extends "res://scripts/state_handler.gd"

var speed

func get_handled_state():
	return "CHARGING"
	
func enter_state(previous_state):
	.enter_state(previous_state)
	
	speed = get_parent().get_starting_speed()
	
func leave_state(new_state):
	.leave_state(new_state)
	
func process_state(delta):
	.process_state(delta)
	if(get_parent().get_charging_distance() > 0):
		if(speed < get_parent().get_max_speed()):
			speed = speed + get_parent().get_charging_acceleration()*delta
			
		var collider = get_parent().move_and_collide_slope(get_parent().get_direction() * Vector2(1,0) * delta * speed)
		get_parent().set_charging_distance(get_parent().get_charging_distance() - speed*delta)
		if(collider != null):
			get_parent().set_state("STUNNED_BY_CRASH")
		elif(not get_parent().get_ground_detector().is_colliding()):
			get_parent().set_state("STUNNED_BY_EXHAUSTION")
	else:
		get_parent().set_state("STUNNED_BY_EXHAUSTION")
