tool

extends "res://scripts/playable_character.gd"

func _ready():
	pass

func _physics_process(delta):
	if(has_weapon()):
		if(Input.is_action_just_pressed("fire")):
			get_weapon().press_trigger()
		if(Input.is_action_pressed("fire")):
			get_weapon().hold_trigger()
		if(Input.is_action_just_released("fire")):
			get_weapon().release_trigger()
			
		if(Input.is_action_pressed("aim_up")):
			get_weapon().set_position(weapon_top_position.get_position())
			get_weapon().set_rotation(weapon_top_position.get_rotation())
		elif(Input.is_action_pressed("aim_down") and (not is_grounded())):
			get_weapon().set_position(weapon_bottom_position.get_position())
			get_weapon().set_rotation(weapon_bottom_position.get_rotation())
		elif(Input.is_action_pressed("aim_up_front")):
			get_weapon().set_position(weapon_top_front_position.get_position())
			get_weapon().set_rotation(weapon_top_front_position.get_rotation())
		elif(Input.is_action_pressed("aim_down_front")):
			get_weapon().set_position(weapon_bottom_front_position.get_position())
			get_weapon().set_rotation(weapon_bottom_front_position.get_rotation())
		else:
			get_weapon().set_position(weapon_front_position.get_position())
			get_weapon().set_rotation(weapon_front_position.get_rotation())


func enter_state(state, previous):
	match state:
		STATES.CROUCHING:
			set_scale(get_scale() * Vector2(1,0.5))
		STATES.FALLING:
			animation_player.play("fall")
		
		STATES.STANDING:
			double_jumped = false
			
			animation_player.play("idle")
		STATES.REGULAR_JUMPING:
			set_gravity_enabled(false)
			jumping_timer = 0
			
			set_velocity(Vector2(0,1) * calculate_starting_velocity_y(get_jump_height(), get_gravity_vector().y))
			
			animation_player.play("jump")
		STATES.DOUBLE_JUMPING:
			set_gravity_enabled(false)
			double_jumping_timer = 0
			
			set_velocity(Vector2(0,1) * calculate_starting_velocity_y(get_double_jump_height(), get_gravity_vector().y))
			
			animation_player.play("jump")
		STATES.WALL_SLIDING:
			set_gravity_enabled(true)
			
			animation_player.play("idle")
		STATES.WALL_JUMPING:
			set_flippedH(not is_flippedH())
			set_gravity_enabled(false)
			wall_jumping_timer = 0
			
			set_velocity(Vector2())
			
			animation_player.play("jump")
		STATES.WALKING:
			animation_player.play("run")
			
		STATES.CLIMBING:
			get_ladder().snap_to(self)
			set_gravity_enabled(false)
		STATES.PUSHED:
			set_velocity(-get_velocity())
			set_acceleration(-get_acceleration())
			
			stunned_timer = 0
			
			set_gravity_enabled(false)
func leave_state(state, new):
	match state:
		STATES.CROUCHING:
			set_scale(get_scale() * Vector2(1,2))
		STATES.REGULAR_JUMPING:
			set_gravity_enabled(true)
		STATES.DOUBLE_JUMPING:
			double_jumped = true
			
			set_gravity_enabled(true)
		STATES.WALL_JUMPING:
			set_gravity_enabled(true)
		STATES.WALL_SLIDING:
			set_gravity_enabled(true)
		STATES.CLIMBING:
			set_gravity_enabled(true)
		STATES.PUSHED:
			set_gravity_enabled(true)
			
func process_state(state, delta):
	match state:
		STATES.REGULAR_JUMPING:
			if(not Input.is_action_pressed("jump") or jumping_timer > calculate_max_airtime(get_jump_height(), get_gravity_vector().y)):
				set_state(STATES.FALLING)
			elif(Input.is_action_pressed("play_up") and is_inside_ladder()):
				set_state(STATES.CLIMBING)
			else:
				set_velocity(get_velocity() + get_gravity_vector() * delta)
				
				move_and_collide(get_velocity() * delta)
				
				var pressed = 0
				
				if(Input.is_action_pressed("play_left")):
					set_flippedH(true)
					pressed = 1
				elif(Input.is_action_pressed("play_right")):
					set_flippedH(false)
					pressed = 1
					
				var collision_info = move_and_collide(Vector2(1,0) * get_direction() * pressed * delta * get_movement_speed())
				
				if(collision_info != null):
					set_state(STATES.WALL_SLIDING)
					set_wall_slide_side(get_direction().x)
				
				jumping_timer += delta
		STATES.DOUBLE_JUMPING:
			if(not Input.is_action_pressed("jump") or double_jumping_timer > calculate_max_airtime(get_double_jump_height(), get_gravity_vector().y)):
				set_state(STATES.FALLING)
			elif(Input.is_action_pressed("play_up") and is_inside_ladder()):
				set_state(STATES.CLIMBING)
			else:
				set_velocity(get_velocity() + get_gravity_vector() * delta)
				
				move_and_collide(get_velocity() * delta)
				
				var pressed = 0
				
				if(Input.is_action_pressed("play_left")):
					set_flippedH(true)
					pressed = 1
				elif(Input.is_action_pressed("play_right")):
					set_flippedH(false)
					pressed = 1
					
				var collision_info = move_and_collide(Vector2(1,0) * get_direction() * delta * pressed * get_movement_speed())
				
				if(collision_info != null):
					set_state(STATES.WALL_SLIDING)
					set_wall_slide_side(get_direction().x)
				double_jumping_timer += delta
		STATES.WALL_JUMPING:
			if(not Input.is_action_pressed("jump") or wall_jumping_timer > 4):
				set_state(STATES.FALLING)
			elif(Input.is_action_pressed("play_up") and is_inside_ladder()):
				set_state(STATES.CLIMBING)
			else:
				move_and_collide(get_gravity_vector() * -1 * delta)
				
				var pressed = 1
				if(Input.is_action_pressed("play_left")):
					set_flippedH(true)
					pressed = 1
				elif(Input.is_action_pressed("play_right")):
					set_flippedH(false)
					pressed = 1
					
				var collision_info = move_and_collide(Vector2(1,0) * get_direction() * delta * pressed * get_movement_speed())
				
				if(collision_info != null):
					set_state(STATES.WALL_SLIDING)
					set_wall_slide_side(get_direction().x)
				wall_jumping_timer += delta
		STATES.WALL_SLIDING:
			if(is_grounded()):
				set_state(STATES.STANDING)
			elif(not test_move(get_global_transform(), Vector2(1, 0) * delta * get_movement_speed() * get_wall_slide_side())):
				print("SIDE: " + String(get_wall_slide_side()))
				set_state(STATES.FALLING)
			elif(Input.is_action_just_pressed("jump") and can_wall_jump()):
				set_state(STATES.WALL_JUMPING)
			else:
				pass
		STATES.FALLING:
			if(is_grounded()):
				set_state(STATES.STANDING)
			elif(Input.is_action_just_pressed("jump") and can_double_jump()):
				set_state(STATES.DOUBLE_JUMPING)
			elif(Input.is_action_pressed("play_up") and is_inside_ladder()):
				set_state(STATES.CLIMBING)
			else:
				var pressed = 0
				if(Input.is_action_pressed("play_left")):
					set_flippedH(true)
					pressed = 1
				elif(Input.is_action_pressed("play_right")):
					set_flippedH(false)
					pressed = 1
					
				var collision_info = move_and_collide(Vector2(1,0) * get_direction() * delta * get_movement_speed() * pressed)
				
				if(collision_info != null):
					set_state(STATES.WALL_SLIDING)
					set_wall_slide_side(get_direction().x)

		STATES.CLIMBING:
			if(Input.is_action_just_pressed("jump")):
				set_state(STATES.REGULAR_JUMPING)
			elif(not is_inside_ladder()):
				set_state(STATES.FALLING)
			else:
				var dir = 0
				
				if(Input.is_action_pressed("play_up")):
					dir = -1
				elif(Input.is_action_pressed("play_down")):
					dir = 1
			
				move_and_collide(Vector2(0, dir) * get_climbing_speed() * delta)
		STATES.CROUCHING:
			if(not Input.is_action_pressed("play_down")):
				set_state(STATES.STANDING)
			else:
				if(Input.is_action_pressed("play_left")):
					set_flippedH(true)
				elif(Input.is_action_pressed("play_right")):
					set_flippedH(false)
		STATES.PUSHED:
			if(stunned_timer >= get_stunned_time()):
				set_state(STATES.FALLING)
			else:
				set_velocity(get_velocity() + get_gravity_vector() * delta)
					
				move_and_collide(get_velocity() * delta)
					
				stunned_timer += delta
		STATES.STANDING:
			if(not is_grounded()):
				set_state(STATES.FALLING)
			elif(Input.is_action_pressed("play_up") and is_inside_ladder()):
				set_state(STATES.CLIMBING)
			elif(Input.is_action_just_pressed("jump") and can_jump()):
				set_state(STATES.REGULAR_JUMPING)
			elif(Input.is_action_pressed("play_left") or Input.is_action_pressed("play_right")):
				set_state(STATES.WALKING)
			elif(Input.is_action_pressed("play_down")):
				set_state(STATES.CROUCHING)
		STATES.WALKING:
			if(not is_grounded()):
				set_state(STATES.FALLING)
			elif(Input.is_action_pressed("play_up") and is_inside_ladder()):
				set_state(STATES.CLIMBING)
			elif(Input.is_action_just_pressed("jump") and can_jump()):
				set_state(STATES.REGULAR_JUMPING)
			elif(Input.is_action_pressed("play_left") or Input.is_action_pressed("play_right")):
				if(Input.is_action_pressed("play_left")):
					set_flippedH(true)
				elif(Input.is_action_pressed("play_right")):
					set_flippedH(false)
					
				move_and_collide_slope(Vector2(1,0) * delta * get_direction()  * get_movement_speed())
			else:
				set_state(STATES.STANDING)
