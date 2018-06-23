extends "res://scripts/state_handler.gd"

export var jump_height = 64 * 4.2 setget set_jump_height, get_jump_height

func get_jump_height():
	return jump_height

func set_jump_height(val):
	jump_height = val
	
func enter_state(previous_state):
	.enter_state(previous_state)
			
	get_parent().set_velocity(Vector2(0,1) * PHYSICS_HELPER.calculate_jump_starting_velocity_y(get_jump_height(), get_parent().get_gravity_vector().y))
			
	get_parent().animation_player.play("jump")
	
func process_state(delta):
	.process_state(delta)
	
	if(not get_parent().is_action_pressed("jump") or get_timer() > PHYSICS_HELPER.calculate_jump_max_airtime(get_jump_height(), get_parent().get_gravity_vector().y)):
		get_parent().set_velocity(Vector2(get_parent().get_velocity().x,0))
		get_parent().set_state("FALLING")
	elif(((get_parent().is_action_pressed("play_up") and get_parent().is_inside_ladder()) or get_parent().is_inside_walled_ladder()) and get_parent().can_enter_state("CLIMBING")):
		get_parent().set_state("CLIMBING")
	else:		
		var vertical_collision_info  = get_parent().apply_velocity_y(delta)
		
		if (vertical_collision_info != null):
			get_parent().set_velocity(Vector2(get_parent().get_velocity().x,0))
			get_parent().set_state("FALLING")
		
		else:
			var pressed = 0
					
			if(get_parent().is_action_pressed("play_left")):
				get_parent().set_flippedH(true)
				get_parent().set_velocity(Vector2(get_parent().get_movement_speed(), get_parent().get_velocity().y))
			
			elif(get_parent().is_action_pressed("play_right")):
				get_parent().set_flippedH(false)
				get_parent().set_velocity(Vector2(get_parent().get_movement_speed(), get_parent().get_velocity().y))
			else:
				get_parent().set_velocity(Vector2(0,get_parent().get_velocity().y))			
			var horizontal_collision_info = get_parent().apply_velocity_x(delta)
					
			if(horizontal_collision_info != null and get_parent().can_enter_state("WALL_SLIDING")):
				get_parent().set_state("WALL_SLIDING")