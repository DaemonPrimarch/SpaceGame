extends "res://scripts/state_handler.gd"

export var wall_jump_height = 64 * 2 setget set_wall_jump_height, get_wall_jump_height
export var angle = -(PI/4)*3 setget set_angle, get_angle

var starting_speed_y
var starting_speed_x
var wall_jump_time

func get_wall_jump_height():
	return wall_jump_height

func set_wall_jump_height(val):
	wall_jump_height = val

func set_angle(value):
	angle = value

func get_angle():
	return angle

func get_handled_state():
	return "WALL_JUMPING"
	
func _ready():
	starting_speed_y = PHYSICS_HELPER.calculate_jump_starting_velocity_y(get_wall_jump_height(), get_parent().get_gravity_vector().y)
	starting_speed_x = starting_speed_y/atan(get_angle())
	wall_jump_time = PHYSICS_HELPER.calculate_jump_max_airtime(wall_jump_height, get_parent().get_gravity_vector().y)

func enter_state(previous_state):
	.enter_state(previous_state)
	
	get_parent().set_flippedH(not get_parent().is_flippedH())
			
	get_parent().set_velocity(Vector2(starting_speed_x,starting_speed_y))
			
	get_parent().animation_player.play("jump")
	
func leave_state(new_state):
	.leave_state(new_state)
	
func process_state(delta):
	.process_state(delta)
	
	if((not Input.is_action_pressed("jump") and get_timer() > 0.5) or get_timer() > wall_jump_time):
		get_parent().set_state("FALLING")
	elif(((Input.is_action_pressed("play_up") and get_parent().is_inside_ladder()) or get_parent().is_inside_walled_ladder()) and get_parent().can_enter_state("CLIMBING")):
		get_parent().set_state("CLIMBING")
	else:		
		var vertical_collision_info  = get_parent().apply_velocity_y(delta)
		
		if (vertical_collision_info != null):
			get_parent().set_state("FALLING")
		else:
			if(get_timer() > 0.5):
				if(Input.is_action_pressed("play_left")):
					get_parent().set_flippedH(true)
				elif(Input.is_action_pressed("play_right")):
					get_parent().set_flippedH(false)
						
			var horizontal_collision_info = get_parent().apply_velocity_x(delta)
					
			if(horizontal_collision_info != null):
				if(get_parent().can_enter_state("WALL_SLIDING")):
					get_parent().set_state("WALL_SLIDING")
				else:
					get_parent().set_velocity(Vector2())
					get_parent().set_state("FALLING")