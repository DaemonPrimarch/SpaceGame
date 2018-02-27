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
		get_parent().set_state("STANDING")
	elif(Input.is_action_just_pressed("jump") and get_parent().can_double_jump()):
		get_parent().set_state("DOUBLE_JUMPING")
	elif(Input.is_action_pressed("play_up") and get_parent().is_inside_ladder()):
		get_parent().set_state("CLIMBING")
	else:
		var pressed = 0
		if(Input.is_action_pressed("play_left")):
			get_parent().set_flippedH(true)
			pressed = 1
			get_parent().set_velocity(Vector2(0,get_parent().get_velocity().y))
		elif(Input.is_action_pressed("play_right")):
			get_parent().set_flippedH(false)
			pressed = 1
			get_parent().set_velocity(Vector2(0,get_parent().get_velocity().y))
					
		var collision_info = get_parent().move_and_collide(Vector2(1,0) * get_parent().get_direction() * delta * (get_parent().get_velocity().x + get_parent().get_movement_speed() * pressed))
				
		if(collision_info != null and get_parent().can_wall_slide()):
			get_parent().set_state("WALL_SLIDING")
			get_parent().set_wall_slide_side(get_parent().get_direction().x)