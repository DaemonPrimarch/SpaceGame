extends "res://scripts/playable_character.gd"

onready var debug_state_label = get_node("DebugStateLabel")
onready var wall_jump_timer = get_node("wall_jump_timer")

var jump_just_pressed = false
var original_gravity_enabled = false
var first_frame_crawling = false

func _ready():
	set_process_input(true)
	set_fixed_process(true)
	debug_state_label.set_text("GROUNDED")
	
func is_jump_just_pressed():
	return jump_just_pressed

func enter_state(state):
	if(state == STATE.REGULAR_JUMPING):
		original_gravity_enabled = gravity_enabled
		set_jumped(true)
		set_gravity_enabled(false)
		set_time_jumping(0)
		debug_state_label.set_text("REGULAR_JUMPING")
		reset_gravity_timer()
	elif(state == STATE.CRAWLING):
		get_node("crawl_space_detector_up").set_enabled(false)
		get_node("crawl_space_detector_down").set_enabled(false)
		get_node("standing_space_detector_right").set_enabled(true)
		get_node("standing_space_detector_left").set_enabled(true)
		set_scale(get_scale() / Vector2(0.5, 2))
		move(Vector2(10, 0))
		first_frame_crawling = true
	elif(state == STATE.CROUCHING):
		pass
	elif(state == STATE.WALL_JUMPING):
		set_jumped(true)
		reset_gravity_timer()
		original_gravity_enabled = gravity_enabled
		set_gravity_enabled(false)
		set_time_wall_jumping(0)
		debug_state_label.set_text("WALL_JUMPING")
		wall_jump_timer.set_wait_time(get_min_wall_jump_time())
		wall_jump_timer.start()
	elif(state == STATE.GROUNDED):
		set_jumped(false)
		set_double_jumped(false)
		set_wall_jumped(false)
		debug_state_label.set_text("GROUNDED")
	elif(state == STATE.FALLING):
		debug_state_label.set_text("FALLING")
	elif(state == STATE.WALL_SLIDING):
		set_flippedH(not is_flippedH())
		debug_state_label.set_text("WALL_SLIDING")
	elif(state == STATE.DOUBLE_JUMPING):
		set_double_jumped(true)
		original_gravity_enabled = gravity_enabled
		set_gravity_enabled(false)
		reset_gravity_timer()
		set_time_double_jumping(0)
		debug_state_label.set_text("DOUBLE_JUMPING")
	elif(state == STATE.CLIMBING):
		original_gravity_enabled = gravity_enabled
		set_gravity_enabled(false)
		debug_state_label.set_text("CLIMBING")

func leave_state(state):
	if(state == STATE.REGULAR_JUMPING):
		set_gravity_enabled(original_gravity_enabled)
		reset_gravity_timer()
	elif(state == STATE.WALL_JUMPING):
		set_gravity_enabled(original_gravity_enabled)
		reset_gravity_timer()
	elif(state == STATE.DOUBLE_JUMPING):
		set_gravity_enabled(original_gravity_enabled)
		reset_gravity_timer()
	elif(state == STATE.CLIMBING):
		set_gravity_enabled(original_gravity_enabled)
		reset_gravity_timer()
	elif(state == STATE.CRAWLING):
		get_node("crawl_space_detector_up").set_enabled(true)
		get_node("crawl_space_detector_down").set_enabled(true)
		get_node("standing_space_detector_right").set_enabled(false)
		get_node("standing_space_detector_left").set_enabled(false)
		set_scale(get_scale() * Vector2(0.5, 2))

func process_state(state, delta):
	if(state == STATE.GROUNDED):
		if(Input.is_action_pressed("jump")):
			set_current_state(STATE.REGULAR_JUMPING)
		elif(not is_on_ground()):
			set_current_state(STATE.FALLING)
		else:
			var dir = 0
			if(Input.is_action_pressed("play_left")):
				set_flippedH(true)
				dir = -1
				play_or_continue_animation("run")
			elif(Input.is_action_pressed("play_right")):
				set_flippedH(false)
				dir = 1
				play_or_continue_animation("run")
			else:
				play_or_continue_animation("idle")
			
			var collision_info = move(Vector2(dir * get_movement_speed() * delta, 0))
			if(collision_info.has_collision() and collision_info.get_collider().is_in_group("terrain") and not collision_info.get_collider().is_in_group("no_crawl") ):
				if(not get_node("crawl_space_detector_up").is_colliding() and not get_node("crawl_space_detector_down").is_colliding()):
					set_current_state(STATE.CRAWLING)
	elif(state == STATE.REGULAR_JUMPING):
		play_or_continue_animation("jumping")
		if(Input.is_action_pressed("jump")):
			var vertical_collision_info = move(get_current_jump_velocity(get_time_jumping())*delta)
			set_time_jumping(get_time_jumping() + delta)
			
			var dir = 0
			if(Input.is_action_pressed("play_left")):
				set_flippedH(true)
				dir = -1
			elif(Input.is_action_pressed("play_right")):
				set_flippedH(false)
				dir = 1
			
			var horizontal_collision_info = move(Vector2(dir * get_movement_speed() * delta, 0))
			
			if(vertical_collision_info.has_collision()):
				set_current_state(STATE.FALLING)
			elif(can_wall_slide() and horizontal_collision_info.has_collision() and horizontal_collision_info.get_collider().is_in_group("terrain")):
				set_current_state(STATE.WALL_SLIDING)
			
			if(time_jumping >= get_max_jump_time()):
				set_current_state(STATE.FALLING)
		else:
			set_current_state(STATE.FALLING)
	elif(state == STATE.WALL_JUMPING):
		play_or_continue_animation("jumping")
		if(Input.is_action_pressed("jump") or wall_jump_timer.get_time_left() > 0):
			if(get_time_wall_jumping() >= get_max_wall_jump_time()):
				set_current_state(STATE.FALLING)
			else:
				var vertical_collision_info = move(Vector2(0,get_current_wall_jump_velocity(get_time_wall_jumping()).y * delta ))
				
				var wall_jump_direction = 1
				if(is_flippedH()):
					wall_jump_direction = -1
				
				var horizontal_collision_info = move(Vector2(get_current_wall_jump_velocity(get_time_wall_jumping()).x, 0) * wall_jump_direction * delta)
				if(vertical_collision_info.has_collision()):
					set_current_state(STATE.FALLING)
				elif(can_wall_slide() and horizontal_collision_info.has_collision() and horizontal_collision_info.get_collider().is_in_group("terrain")):
					set_current_state(STATE.WALL_SLIDING)
				set_time_wall_jumping(get_time_wall_jumping() + delta)
		
		else:
			set_current_state(STATE.FALLING)

	elif(state == STATE.DOUBLE_JUMPING):
		play_or_continue_animation("jumping")
		
		if(Input.is_action_pressed("jump")):
			var vertical_collision_info = move(get_current_double_jump_velocity(get_time_double_jumping())*delta)
			set_time_double_jumping(get_time_double_jumping() + delta)
			
			var dir = 0
			if(Input.is_action_pressed("play_left")):
				set_flippedH(true)
				dir = -1
			elif(Input.is_action_pressed("play_right")):
				set_flippedH(false)
				dir = 1
			
			var horizontal_collision_info = move(Vector2(dir * get_movement_speed() * delta, 0))
			
			if(vertical_collision_info.has_collision()):
				set_current_state(STATE.FALLING)
			if(can_wall_slide() and horizontal_collision_info.has_collision() and horizontal_collision_info.get_collider().is_in_group("terrain")):
				set_current_state(STATE.WALL_SLIDING)
			
			if(get_time_double_jumping() >= get_max_double_jump_time()):
				set_current_state(STATE.FALLING)
		else:
			set_current_state(STATE.FALLING)
	elif(state == STATE.FALLING):
		play_or_continue_animation("falling")

		if(not has_double_jumped() and is_jump_just_pressed() and can_double_jump()):
			set_current_state(STATE.DOUBLE_JUMPING)
		else:
			if(is_on_ground()):
				set_current_state(STATE.GROUNDED)
			else:
				var dir = 0
				if(Input.is_action_pressed("play_left")):
					set_flippedH(true)
					dir = -1
				elif(Input.is_action_pressed("play_right")):
					set_flippedH(false)
					dir = 1
					
				var collision_info = move(Vector2(dir * get_movement_speed() * delta, 0))
				if(can_wall_slide() and collision_info.has_collision() and collision_info.get_collider().is_in_group("terrain")):
					set_current_state(STATE.WALL_SLIDING)
	elif(state == STATE.CLIMBING):
		play_or_continue_animation("idle")

		if(Input.is_action_pressed("up")):
			move(Vector2(0, -get_climbing_speed() * delta))
		elif(Input.is_action_pressed("down")):
			move(Vector2(0, get_climbing_speed() * delta))
		if(Input.is_action_pressed("play_left")):
			move(Vector2(-get_climbing_speed() * delta, 0))
		elif(Input.is_action_pressed("play_right")):
			move(Vector2(get_climbing_speed() * delta, 0))
	elif(state == STATE.WALL_SLIDING):
		play_or_continue_animation("idle")
		if(can_wall_jump() and is_jump_just_pressed()):
			set_current_state(STATE.WALL_JUMPING)
		else:
			var dir = 1
			if(is_flippedH()):
				dir = -1
			
			if(not test_move(Vector2(10, 0) * dir * -1)):
				set_current_state(STATE.FALLING)
			else:
				if(is_on_ground()):
					set_current_state(STATE.GROUNDED)
	elif(state == STATE.CRAWLING):
		var dir = 0
		if(Input.is_action_pressed("play_left")):
			set_flippedH(true)
			dir = -1
		elif(Input.is_action_pressed("play_right")):
			set_flippedH(false)
			dir = 1
			
		move(Vector2(dir * get_crawl_speed() * delta, 0))
		
		if(not get_node("standing_space_detector_left").is_colliding() and not get_node("standing_space_detector_right").is_colliding() and not first_frame_crawling):
			set_current_state(STATE.GROUNDED)
		
		first_frame_crawling = false
		
	jump_just_pressed = false

func _on_wall_jump_timer_timeout():
	wall_jump_timer.stop()

func _input(ev):
	if(ev.is_action_pressed("shoot")):
		gun.press_trigger()
	elif(ev.is_action_released("shoot")):
		gun.release_trigger()
	elif(ev.is_action_pressed("jump")):
		jump_just_pressed = true
	elif(ev.is_action_pressed("set_climb_on")):
		set_current_state(STATE.CLIMBING)
	elif(ev.is_action_pressed("set_climb_off")):
		set_current_state(STATE.FALLING)

func _fixed_process(delta):
	if(Input.is_action_pressed("aim_full_up")):
		if(gun.get_orientation() != gun.ORIENTATION.FULL_UP):
			gun.set_aim_orientation(gun.ORIENTATION.FULL_UP)
	elif(Input.is_action_pressed("aim_up")):
		if(gun.get_orientation() != gun.ORIENTATION.UP):
			gun.set_aim_orientation(gun.ORIENTATION.UP)
	elif(Input.is_action_pressed("aim_full_down")):
		if(gun.get_orientation() != gun.ORIENTATION.FULL_DOWN):
			gun.set_aim_orientation(gun.ORIENTATION.FULL_DOWN)
	elif(Input.is_action_pressed("aim_down")):
		if(gun.get_orientation() != gun.ORIENTATION.DOWN):
			gun.set_aim_orientation(gun.ORIENTATION.DOWN)
	elif(gun.get_orientation() != gun.ORIENTATION.FRONT):
		gun.set_aim_orientation(gun.ORIENTATION.FRONT)