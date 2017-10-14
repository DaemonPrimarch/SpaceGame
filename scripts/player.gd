
extends "res://scripts/entity.gd"

#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = get_node("sprite")

onready var animation_player = get_node("AnimationPlayer")

onready var debug_state_label = get_node("DebugStateLabel")

onready var wall_jump_timer

var wall_jump_timer_running = false

enum STATE {REGULAR_JUMPING, DOUBLE_JUMPING, WALL_JUMPING, WALL_SLIDING, GROUNDED, FALLING, CLIMBING, CRAWLING}

var current_state = STATE.GROUNDED

#MY STUFF

var current_animation = "idle"

var original_gravity_enabled = false

var time_jumping = 0
var jumped = false
var jumping_released = false

var time_wall_jumping = 0

var time_double_jumping = 0
var double_jumped = false

var first_frame_crawling = false

var wall_jump_direction = 0

export var jump_height = 64 * 4
export var double_jump_height = 64 * 2
export var climbing_speed = 64 * 4
export var crawl_speed = 64 * 2
export var wall_jump_height = 64 * 2
export var wall_jump_length = 64 * 4
func _ready():
	wall_jump_timer = Timer.new()
	wall_jump_timer.set_name("wall_jump_timer")
	wall_jump_timer.set_wait_time(get_min_wall_jump_time())
	
	wall_jump_timer.connect("timeout", self, "_on_wall_jump_timer_timeout")
	
	add_child(wall_jump_timer)
	
	set_fixed_process(true)
	set_process_input(true)
	debug_state_label.set_text("GROUNDED")

func get_crawl_speed():
	return crawl_speed

func get_current_animation():
	return current_animation

func play_or_continue_animation(animation):
	if(get_current_animation() != animation):
		animation_player.play(animation)
		current_animation = animation

func get_climbing_speed():
	return climbing_speed

func get_wall_jump_length():
	return wall_jump_length

func get_wall_jump_height():
	return wall_jump_height

func has_jumped():
	return jumped

func has_double_jumped():
	return double_jumped

func get_jump_height():
	return jump_height

func get_jump_decelleration():
	return get_gravity_vector()

#Not entirely sure about the implementation, the .y disturbs me.
func get_max_jump_time():
	return sqrt(get_jump_height()/(get_jump_decelleration().y/2))
	
func get_max_wall_jump_time():
	return sqrt(get_wall_jump_height()/(get_jump_decelleration().y/2))

func get_min_wall_jump_time():
	var tmin = -get_starting_wall_jump_velocity().y/((get_gravity_vector().y/2)*(1+(get_starting_wall_jump_velocity().x/get_movement_speed())*(get_starting_wall_jump_velocity().x/get_movement_speed())))
	if(tmin > get_max_wall_jump_time()):
		#rounding error fixer
		return 0.25 + sqrt(-get_starting_wall_jump_velocity().y*get_max_wall_jump_time()/((get_gravity_vector().y/2)*(1+(get_starting_wall_jump_velocity().x/get_movement_speed())*(get_starting_wall_jump_velocity().x/get_movement_speed()))))
	else:
		return tmin

func start_wall_jump_timer():
	wall_jump_timer.start()
	wall_jump_timer_running = true

func get_starting_wall_jump_velocity():
	return Vector2(get_wall_jump_length()/get_max_wall_jump_time(), -get_wall_jump_height()/get_max_wall_jump_time() - get_max_wall_jump_time()*get_gravity_vector().y/2)
	
func get_starting_jump_velocity():
	return get_jump_decelleration()*get_max_jump_time()*-1

func get_current_jump_velocity():
	return get_starting_jump_velocity()+get_jump_decelleration()*time_jumping

func get_current_wall_jump_velocity():
	return get_starting_wall_jump_velocity()+get_jump_decelleration()*time_wall_jumping

func get_double_jump_height():
	return double_jump_height

func get_double_jump_decelleration():
	return get_gravity_vector()
	
func get_max_double_jump_time():
	return sqrt(get_double_jump_height()/(get_double_jump_decelleration().y/2))

func get_starting_double_jump_velocity():
	return get_double_jump_decelleration()*get_max_double_jump_time()*-1

func get_current_double_jump_velocity():
	return get_starting_double_jump_velocity()+get_double_jump_decelleration()*time_double_jumping

func get_current_state():
	return current_state

func set_current_state(state):
	if(state != get_current_state()):
		leave_state(get_current_state())
		enter_state(state)
		current_state = state
		
func enter_state(state):
	if(state == STATE.REGULAR_JUMPING):
		jumped = true
		original_gravity_enabled = gravity_enabled
		set_gravity_enabled(false)
		time_jumping = 0
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
	elif(state == STATE.WALL_JUMPING):
		jumped = true
		reset_gravity_timer()
		original_gravity_enabled = gravity_enabled
		print(get_min_wall_jump_time())
		
		if(is_flippedH()):
			wall_jump_direction = 1
		else:
			wall_jump_direction = -1
			
		set_flippedH(not is_flippedH())
			
		set_gravity_enabled(false)
		time_wall_jumping = 0
		debug_state_label.set_text("WALL_JUMPING")
		start_wall_jump_timer()
	elif(state == STATE.GROUNDED):
		jumped = false
		double_jumped = false
		debug_state_label.set_text("GROUNDED")
	elif(state == STATE.FALLING):
		debug_state_label.set_text("FALLING")
	elif(state == STATE.WALL_SLIDING):
		debug_state_label.set_text("WALL_SLIDING")
	elif(state == STATE.DOUBLE_JUMPING):
		double_jumped = true
		original_gravity_enabled = gravity_enabled
		set_gravity_enabled(false)
		reset_gravity_timer()
		time_double_jumping = 0
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
			move(get_current_jump_velocity()*delta)
			time_jumping += delta
			
			var dir = 0
			if(Input.is_action_pressed("play_left")):
				set_flippedH(true)
				dir = -1
			elif(Input.is_action_pressed("play_right")):
				set_flippedH(false)
				dir = 1
			
			var collision_info = move(Vector2(dir * get_movement_speed() * delta, 0))
			
			if(collision_info.has_collision() and collision_info.get_collider().is_in_group("terrain")):
				set_current_state(STATE.WALL_SLIDING)
			
			if(time_jumping >= get_max_jump_time()):
				set_current_state(STATE.FALLING)
		else:
			set_current_state(STATE.FALLING)
	elif(state == STATE.WALL_JUMPING):
		if(not wall_jump_timer_running):
			if(Input.is_action_pressed("play_left")):
				set_flippedH(true)
				wall_jump_direction = -1
			elif(Input.is_action_pressed("play_right")):
				set_flippedH(false)
				wall_jump_direction = 1
		play_or_continue_animation("jumping")
		if(Input.is_action_pressed("jump") or wall_jump_timer_running):
			if(time_wall_jumping >= get_max_wall_jump_time()):
				set_current_state(STATE.FALLING)
			else:
				move(Vector2(0,get_current_wall_jump_velocity().y * delta ))
				var collision_info = move(Vector2(get_current_wall_jump_velocity().x, 0) * wall_jump_direction * delta)
	
				if(collision_info.has_collision() and collision_info.get_collider().is_in_group("terrain")):
					set_current_state(STATE.WALL_SLIDING)
				time_wall_jumping += delta
		
		else:
			set_current_state(STATE.FALLING)

	elif(state == STATE.DOUBLE_JUMPING):
		play_or_continue_animation("jumping")
		
		if(Input.is_action_pressed("jump")):
			move(get_current_double_jump_velocity()*delta)
			time_double_jumping += delta
			
			var dir = 0
			if(Input.is_action_pressed("play_left")):
				set_flippedH(true)
				dir = -1
			elif(Input.is_action_pressed("play_right")):
				set_flippedH(false)
				dir = 1
			
			var collision_info = move(Vector2(dir * get_movement_speed() * delta, 0))
			
			if(collision_info.has_collision() and collision_info.get_collider().is_in_group("terrain")):
				set_current_state(STATE.WALL_SLIDING)
			
			if(time_double_jumping >= get_max_double_jump_time()):
				set_current_state(STATE.FALLING)
		else:
			set_current_state(STATE.FALLING)
	elif(state == STATE.FALLING):
		play_or_continue_animation("falling")
		if(wall_jump_timer_running):
			var collision_info = move(Vector2(wall_jump_direction * get_starting_wall_jump_velocity().x * delta, 0))
			if(collision_info.has_collision() and collision_info.get_collider().is_in_group("terrain")):
				set_current_state(STATE.WALL_SLIDING)
		else:
			if(Input.is_action_pressed("jump") and not has_double_jumped() and jumping_released):
				set_current_state(STATE.DOUBLE_JUMPING)
				jumping_released = false
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
					if(collision_info.has_collision() and collision_info.get_collider().is_in_group("terrain")):
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
		if(Input.is_action_pressed("jump")):
			set_current_state(STATE.WALL_JUMPING)
		else:
			if(is_flippedH()):
				if(not test_move(Vector2(-1, 0))):
					set_current_state(STATE.FALLING)
				else:
					if(is_on_ground()):
						set_current_state(STATE.GROUNDED)
			else:
				if(not test_move(Vector2(1, 0))):
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
		
func _fixed_process(delta):
	process_state(get_current_state(), delta)
	
	if(Input.is_action_pressed("set_climb_on")):
		set_current_state(STATE.CLIMBING)
	elif(Input.is_action_pressed("set_climb_off")):
		set_current_state(STATE.FALLING)
	#if(Input.is_action_pressed("shoot")):
		#if(new_animation == "falling"):
		#	new_animation = "falling_weapon"
		#elif(new_animation == "jumping"):
		#	new_animation = "jumping_weapon"
		#elif(new_animation == "run"):
		#	new_animation = "run_weapon"
		#elif(new_animation == "idle"):
		#	new_animation = "standing_weapon_ready"
			
func _on_shoot_countdown_timeout():
	pass
	#shooting = false

func _on_wall_jump_timer_timeout():
	print("stop")
	wall_jump_timer_running = false
	wall_jump_timer.stop()

func _input(ev):
	if(ev.is_action_pressed("jump")):
		if(not has_jumped()):
			jumping_released = false

	elif(ev.is_action_released("jump")):
		jumping_released = true
