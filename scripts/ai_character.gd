extends "res://scripts/playable_character.gd"

var tracking_player
var tracked_player

var original_gravity_enabled

onready var label = get_node("Label")

func is_tracking_player():
	return tracking_player

func get_tracked_player():
	return tracked_player
	
func calulate_closest_player():
	if(get_tree().get_nodes_in_group("tracked").size() > 0):
		tracking_player = true
		tracked_player = get_tree().get_nodes_in_group("tracked")[0]
	else:
		tracking_player = false
		
func _fixed_process(delta):
	calulate_closest_player()

func enter_state(state):
	if(state == STATE.GROUNDED):
		set_double_jumped(false)
	elif(state == STATE.REGULAR_JUMPING):
		original_gravity_enabled = gravity_enabled
		set_jumped(true)
		set_gravity_enabled(false)
		set_time_jumping(0)
		reset_gravity_timer()
		label.set_text("REGULAR_JUMPING")
	elif(state == STATE.DOUBLE_JUMPING):
		original_gravity_enabled = gravity_enabled
		set_double_jumped(true)
		set_gravity_enabled(false)
		set_time_double_jumping(0)
		reset_gravity_timer()
		label.set_text("DOUBLE_JUMPING")

func leave_state(state):
	if(state == STATE.GROUNDED):
		pass
	elif(state == STATE.REGULAR_JUMPING):
		set_gravity_enabled(true)
	elif(state == STATE.DOUBLE_JUMPING):
		set_gravity_enabled(original_gravity_enabled)
		reset_gravity_timer()

func process_state(state, delta):	
	if(state == STATE.GROUNDED):
		label.set_text("GROUNDED")
		play_or_continue_animation("run")
		if(is_tracking_player()):
			if(get_tracked_player().get_pos().x <= get_pos().x):
				set_flippedH(true)
			else:
				set_flippedH(false)
			
			if(get_tracked_player().get_pos().y < (get_pos().y - 64)):
				set_current_state(STATE.REGULAR_JUMPING)
			else:
				move(Vector2((get_tracked_player().get_pos().x - get_pos().x)/abs((get_pos().x - get_tracked_player().get_pos().x)), 0) * get_movement_speed() * delta / 2)
	elif(state == STATE.REGULAR_JUMPING):
		label.set_text("REGULAR_JUMPING")
		play_or_continue_animation("jumping")
		
		var dir = 0
		
		if(is_tracking_player()):
			if(get_tracked_player().get_pos().x <= get_pos().x):
				dir = -1
				set_flippedH(true)
			else:
				dir = 1
				set_flippedH(false)
				
		var vertical_collision_info = move(get_current_jump_velocity(get_time_jumping())*delta)
		time_jumping += delta
			
		var horizontal_collision_info = move(Vector2(dir * get_movement_speed() * delta, 0))
			
		if(vertical_collision_info.has_collision()):
			set_current_state(STATE.FALLING)
		elif(horizontal_collision_info.has_collision() and horizontal_collision_info.get_collider().is_in_group("terrain")):
			#set_current_state(STATE.WALL_SLIDING)
			pass
			
		if(time_jumping >= get_max_jump_time()):
			set_current_state(STATE.FALLING)
	elif(state == STATE.FALLING):
		label.set_text("FALLING")
		
		if(is_tracking_player()):
			if(get_tracked_player().get_pos().x <= get_pos().x):
				set_flippedH(true)
			else:
				set_flippedH(false)
				
		if(get_tracked_player().get_pos().y < (get_pos().y - 10) and not has_double_jumped()):
			set_current_state(STATE.DOUBLE_JUMPING)
		elif(is_on_ground()):
			set_current_state(STATE.GROUNDED)
	elif(state == STATE.WALL_SLIDING):
		label.set_text("WALL_SLIDING")
	elif(state == STATE.DOUBLE_JUMPING):
		label.set_text("DOUBLE_JUMPING")
		play_or_continue_animation("jumping")
		
		var vertical_collision_info = move(get_current_double_jump_velocity(get_time_double_jumping())*delta)
		time_double_jumping += delta
			
		var dir = 0
		if(is_tracking_player()):
			if(get_tracked_player().get_pos().x <= get_pos().x):
				set_flippedH(true)
				dir = -1
			else:
				set_flippedH(false)
				dir = 1
			
		var horizontal_collision_info = move(Vector2(dir * get_movement_speed() * delta, 0))
			
		if(vertical_collision_info.has_collision()):
			set_current_state(STATE.FALLING)
		if(horizontal_collision_info.has_collision() and horizontal_collision_info.get_collider().is_in_group("terrain")):
			#set_current_state(STATE.WALL_SLIDING)
			pass
			
		if(time_double_jumping >= get_max_double_jump_time()):
			set_current_state(STATE.FALLING)
			
			
			