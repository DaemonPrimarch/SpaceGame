extends "res://scripts/state_handler.gd"

func get_handled_state():
	return "WALL_SLIDING"

func enter_state(previous_state):
	.enter_state(previous_state)
	
	get_parent().set_velocity(Vector2(0, get_parent().get_velocity().y))
	
func leave_state(new_state):
	.leave_state(new_state)
	
func process_state(delta):
	.process_state(delta)
	
	if(get_parent().is_grounded()):
		get_parent().set_state(get_parent().STATES.STANDING)
	elif(not get_parent().test_move(get_parent().get_global_transform(), Vector2(1, 0) * delta * get_parent().get_movement_speed() * get_parent().get_wall_slide_side())):
		print("SIDE: " + String(get_parent().get_wall_slide_side()))
		get_parent().set_state(get_parent().STATES.FALLING)
	elif(Input.is_action_just_pressed("jump") and get_parent().can_wall_jump()):
		get_parent().set_state(get_parent().STATES.WALL_JUMPING)
	else:
		pass