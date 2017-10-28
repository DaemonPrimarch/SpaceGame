extends "res://scripts/playable_character.gd"

onready var debug_state_label = get_node("DebugStateLabel")
onready var wall_jump_timer = get_node("wall_jump_timer")
onready var push_timer = get_node("push_timer")

var jump_just_pressed = false
var original_gravity_enabled = false
var first_frame_crawling = false

var escaping_ladder = false

var continuing_previous_movement = true

var already_loaded_2 = false

var save_data = {}

func _ready():
	if(not already_loaded_2):
		set_process_input(true)
		set_fixed_process(true)
		debug_state_label.set_text("GROUNDED")
		already_loaded_2 = true
	
func get_save_data():
	return save_data
	
func set_ladder(val):
	if(val == null):
		escaping_ladder = false
	.set_ladder(val)

func on_collision(object):
	pass
	#print("COLLISION")

func is_jump_just_pressed():
	return jump_just_pressed

func enter_state(state, old_state):
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
		set_scale(get_scale() / Vector2(0.5, 2))
	elif(state == STATE.WALL_JUMPING):
		set_jumped(true)
		set_flippedH(not is_flippedH())
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
		var gun  = get_node("gun")
		gun.set_pos(gun.get_pos() * Vector2(-1,1))
		gun.set_scale(gun.get_scale() * Vector2(-1,1))
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
		get_ladder().snap_to_ladder(self)
		var gun  = get_node("gun")
		gun.set_pos(gun.get_pos() * Vector2(-1,1))
		gun.set_scale(gun.get_scale() * Vector2(-1,1))
		debug_state_label.set_text("CLIMBING")
	elif(state == STATE.PUSHED):
		original_gravity_enabled = gravity_enabled
		set_gravity_enabled(false)
		set_time_pushed(0)
		debug_state_label.set_text("PUSHED")

		push_timer.set_wait_time(get_push_time_extended())
		push_timer.start()

func leave_state(state, new_state):
	if(state == STATE.REGULAR_JUMPING):
		set_gravity_enabled(original_gravity_enabled)
		reset_gravity_timer()
	elif(state == STATE.WALL_JUMPING):
		set_gravity_enabled(original_gravity_enabled)
		reset_gravity_timer()
	elif(state == STATE.DOUBLE_JUMPING):
		set_gravity_enabled(original_gravity_enabled)
		reset_gravity_timer()
	elif(state == STATE.WALL_SLIDING):
		var gun  = get_node("gun")
		gun.set_pos(gun.get_pos() * Vector2(-1,1))
		gun.set_scale(gun.get_scale() * Vector2(-1,1))
	elif(state == STATE.CLIMBING):
		set_gravity_enabled(original_gravity_enabled)
		var gun  = get_node("gun")
		gun.set_pos(gun.get_pos() * Vector2(-1,1))
		gun.set_scale(gun.get_scale() * Vector2(-1,1))
		reset_gravity_timer()
	elif(state == STATE.CRAWLING):
		get_node("crawl_space_detector_up").set_enabled(true)
		get_node("crawl_space_detector_down").set_enabled(true)
		get_node("standing_space_detector_right").set_enabled(false)
		get_node("standing_space_detector_left").set_enabled(false)
		set_scale(get_scale() * Vector2(0.5, 2))

	elif(state == STATE.PUSHED):
		set_gravity_enabled(original_gravity_enabled)
		reset_gravity_timer()
	elif(state == STATE.FALLING):
		push_timer.stop()
	elif(state == STATE.CROUCHING):
		set_scale(get_scale() / Vector2(2, 0.5))

func process_state(state, delta):
	if(state == STATE.GROUNDED):
		if(Input.is_action_pressed("jump")):
			if(is_inside_ladder()):
				set_current_state(STATE.CLIMBING)
			else:
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
			if(is_inside_ladder() and not escaping_ladder):
				set_current_state(STATE.CLIMBING)
			else:
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
				
				if(horizontal_collision_info.has_collision()):
					if(is_in_ladder()):
						set_current_state(STATE.CLIMBING)
					elif(can_wall_slide() and horizontal_collision_info.get_collider().is_in_group("terrain")):
						set_current_state(STATE.WALL_SLIDING)
					else:
						#set_current_state(STATE.FALLING)
						pass
				elif(vertical_collision_info.has_collision()):
					set_current_state(STATE.FALLING)
				
				if(time_jumping >= get_max_jump_time()):
					set_current_state(STATE.FALLING)
		else:
			set_current_state(STATE.FALLING)
	elif(state == STATE.WALL_JUMPING):
		play_or_continue_animation("jumping")
		if(Input.is_action_pressed("jump") or wall_jump_timer.get_time_left() > 0):
			if(get_time_wall_jumping() >= get_max_wall_jump_time()):
				continuing_previous_movement = true
				set_current_state(STATE.FALLING)
			else:
				if(is_inside_ladder()):
					set_current_state(STATE.CLIMBING)
				else:
					var vertical_collision_info = move(Vector2(0,get_current_wall_jump_velocity(get_time_wall_jumping()).y * delta ))
					
					var wall_jump_direction = 1
					if(is_flippedH()):
						wall_jump_direction = -1
					
					var horizontal_collision_info = move(Vector2(get_current_wall_jump_velocity(get_time_wall_jumping()).x, 0) * wall_jump_direction * delta)
					if(vertical_collision_info.has_collision()):
						set_current_state(STATE.FALLING)
					elif(not is_in_ladder() and can_wall_slide() and horizontal_collision_info.has_collision() and horizontal_collision_info.get_collider().is_in_group("terrain")):
						set_current_state(STATE.WALL_SLIDING)
					set_time_wall_jumping(get_time_wall_jumping() + delta)
		else:
			set_current_state(STATE.FALLING)

	elif(state == STATE.DOUBLE_JUMPING):
		play_or_continue_animation("jumping")
		
		if(Input.is_action_pressed("jump")):
			if(is_inside_ladder()):
				set_current_state(STATE.CLIMBING)
			else:
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
				if(not is_in_ladder() and can_wall_slide() and horizontal_collision_info.has_collision() and horizontal_collision_info.get_collider().is_in_group("terrain")):
					set_current_state(STATE.WALL_SLIDING)
				
				if(get_time_double_jumping() >= get_max_double_jump_time()):
					set_current_state(STATE.FALLING)
		else:
			set_current_state(STATE.FALLING)
	elif(state == STATE.FALLING):
		play_or_continue_animation("falling")
		if(is_inside_ladder() and is_jump_just_pressed()):
			set_current_state(STATE.CLIMBING)
		elif(not has_double_jumped() and is_jump_just_pressed() and can_double_jump()):
			continuing_previous_movement = false
			set_current_state(STATE.DOUBLE_JUMPING)
		else:
			if(is_on_ground()):
				continuing_previous_movement = false
				set_current_state(STATE.GROUNDED)
			else:
				var dir = 0
				if(push_timer.get_time_left() <= 0):
					if(Input.is_action_pressed("play_left")):
						set_flippedH(true)
						continuing_previous_movement = false
						dir = -1
					elif(Input.is_action_pressed("play_right")):
						set_flippedH(false)
						dir = 1
						continuing_previous_movement = false
			
				if(continuing_previous_movement):
					dir = 1
					
					if(is_flippedH()):
						dir = -1
					
					
				var collision_info = move(Vector2(dir * get_movement_speed() * delta, 0))
				if(not is_in_ladder() and can_wall_slide() and collision_info.has_collision() and collision_info.get_collider().is_in_group("terrain")):
					continuing_previous_movement = false
					set_current_state(STATE.WALL_SLIDING)
	elif(state == STATE.CLIMBING):
		play_or_continue_animation("idle")

		if(Input.is_action_pressed("up")):
			move(Vector2(0, -get_climbing_speed() * delta))
		elif(Input.is_action_pressed("down")):
			move(Vector2(0, get_climbing_speed() * delta))
		if(not is_inside_ladder() or is_jump_just_pressed()):
			if(Input.is_action_pressed("play_right") or Input.is_action_pressed("play_left")):
				escaping_ladder = true
				set_current_state(STATE.REGULAR_JUMPING) 
			else:
				set_current_state(STATE.FALLING)
	elif(state == STATE.WALL_SLIDING):
		play_or_continue_animation("idle")
		if(can_wall_jump() and is_jump_just_pressed()):
			set_current_state(STATE.WALL_JUMPING)
		else:
			var dir = 1
			if(is_flippedH()):
				dir = -1
			
			if(not test_move(Vector2(1, 0) * dir )):
				set_current_state(STATE.FALLING)
			else:
				if(is_on_ground()):
					set_current_state(STATE.GROUNDED)
				elif(is_in_ladder()):
					set_current_state(STATE.FALLING)
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
	elif(state == STATE.CROUCHING):
		if(not Input.is_action_pressed("play_down")):
			set_current_state(STATE.GROUNDED)
		else:
			var dir = 0
			if(Input.is_action_pressed("play_left")):
				set_flippedH(true)
				dir = -1
			elif(Input.is_action_pressed("play_right")):
				set_flippedH(false)
				dir = 1
		
	elif(state == STATE.PUSHED):
		var collision_info_vertical
		var collision_info_horizontal
		if(is_flippedH()):
			collision_info_vertical = move(Vector2(0,get_push_speed().y + get_jump_decelleration().y*get_time_pushed())*delta)
			collision_info_horizontal = move(Vector2(get_push_speed().x*delta,0))
		else:
			collision_info_vertical = move(Vector2(0,get_push_speed().y + get_jump_decelleration().y*get_time_pushed())*delta)
			collision_info_horizontal = move(Vector2(-1*get_push_speed().x*delta,0))
		set_time_pushed(get_time_pushed() + delta)
		
		if(collision_info_horizontal.has_collision() and collision_info_horizontal.get_collider().is_in_group("terrain")):
			set_current_state(STATE.WALL_SLIDING)
		elif((collision_info_vertical.has_collision() and collision_info_vertical.get_collider().is_in_group("terrain")) or get_time_pushed() >= get_push_time()):
			set_current_state(STATE.FALLING)
	jump_just_pressed = false

func _on_wall_jump_timer_timeout():
	wall_jump_timer.stop()

func _on_push_timer_timeout():
	push_timer.stop()

func _input(ev):
	if(get_current_state() == STATE.CLIMBING):
		pass
	elif(get_current_state() == STATE.GROUNDED):
		if(ev.is_action_pressed("play_down")):
			set_current_state(STATE.CROUCHING)
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
		gun.set_current_point(gun.FULL_UP)
	elif(Input.is_action_pressed("aim_up")):
		gun.set_current_point(gun.UP)
	elif(Input.is_action_pressed("aim_full_down") and get_current_state() != STATE.CROUCHING):
		gun.set_current_point(gun.FULL_DOWN)
	elif(Input.is_action_pressed("aim_down")):
		gun.set_current_point(gun.DOWN)
	else:
		gun.set_current_point(gun.FRONT)

func push(time, time_extended, speed):
	set_push_speed(speed)
	set_push_time(time)
	set_push_time_extended(time_extended)
	set_current_state(STATE.PUSHED)
