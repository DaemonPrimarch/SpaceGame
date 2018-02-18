extends "res://scripts/state_handler.gd"

func get_handled_state():
	return "FALLING"
	
func enter_state(previous_state):
	.enter_state(previous_state)
	
	get_parent().animation_player.play("fall")
	
func leave_state(new_state):
	.leave_state(new_state)
	
func process_state(delta):
	.process_state(delta)

	
	if(get_parent().is_grounded()):
		get_parent().set_state(get_parent().STATES.STANDING)
	elif(Input.is_action_just_pressed("jump") and get_parent().can_double_jump()):
		get_parent().set_state(get_parent().STATES.DOUBLE_JUMPING)
	elif(Input.is_action_pressed("play_up") and get_parent().is_inside_ladder()):
		get_parent().set_state(get_parent().STATES.CLIMBING)
	else:
		var pressed = 0
		if(Input.is_action_pressed("play_left")):
			get_parent().set_flippedH(true)
			pressed = 1
		elif(Input.is_action_pressed("play_right")):
			get_parent().set_flippedH(false)
			pressed = 1
					
		var collision_info = get_parent().move_and_collide(Vector2(1,0) * get_parent().get_direction() * delta * get_parent().get_movement_speed() * pressed)
				
		if(collision_info != null):
			get_parent().set_state(get_parent().STATES.WALL_SLIDING)
			get_parent().set_wall_slide_side(get_parent().get_direction().x)