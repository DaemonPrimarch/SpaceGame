extends "res://scripts/state_handler.gd"

func get_handled_state():
	return "WALL_SLIDING"

func enter_state(previous_state):
	.enter_state(previous_state)
	
	get_parent().set_velocity(Vector2(0, get_parent().get_velocity().y))
	
func leave_state(new_state):
	.leave_state(new_state)
	
func can_continue():
	return get_parent().wall_slide_detector_up.is_colliding() and get_parent().can_wall_slide_on_node(get_parent().wall_slide_detector_up.get_collider())
	
func process_state(delta):
	.process_state(delta)
	
	if(get_parent().is_grounded()):
		get_parent().set_state("STANDING")
	elif(not can_continue()):
		get_parent().set_state("FALLING")
	elif(Input.is_action_just_pressed("jump") and get_parent().can_wall_jump()):
		get_parent().set_state("WALL_JUMPING")
	else:
		pass