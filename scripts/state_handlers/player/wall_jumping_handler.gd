extends "res://scripts/state_handler.gd"

export var wall_jump_height = 64 * 2 setget set_wall_jump_height, get_wall_jump_height
export var angle = -(PI/4)*3 setget set_angle, get_angle

var starting_speed_y
var starting_speed_x

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
	set_no_gravity(true)
	starting_speed_y = get_parent().calculate_starting_velocity_y(get_wall_jump_height(), get_parent().get_gravity_vector().y)
	starting_speed_x = starting_speed_y/atan(get_angle())

func enter_state(previous_state):
	.enter_state(previous_state)
	
	get_parent().set_flippedH(not get_parent().is_flippedH())
			
	get_parent().set_velocity(Vector2(starting_speed_x,starting_speed_y))
			
	get_parent().animation_player.play("jump")
	
func leave_state(new_state):
	.leave_state(new_state)
	
func process_state(delta):
	.process_state(delta)
	
	if((not Input.is_action_pressed("jump") and get_timer() > 0.5) or get_timer() > 4):
		get_parent().set_state("FALLING")
	elif(Input.is_action_pressed("play_up") and get_parent().is_inside_ladder()):
		get_parent().set_state("CLIMBING")
	else:
		get_parent().set_velocity(get_parent().get_velocity() + get_parent().get_gravity_vector() * delta)
				
		var vertical_collision_info  = get_parent().move_and_collide(get_parent().get_velocity() * Vector2(0,1) * delta)
		
		if (vertical_collision_info != null):
			get_parent().set_velocity(Vector2(get_parent().get_velocity().x,0))
			get_parent().set_state("FALLING")
				
		else:
			if(get_timer() > 0.5):
				if(Input.is_action_pressed("play_left")):
					get_parent().set_flippedH(true)
				elif(Input.is_action_pressed("play_right")):
					get_parent().set_flippedH(false)
						
			var horizontal_collision_info = get_parent().move_and_collide(Vector2(starting_speed_x,0) * get_parent().get_direction() * delta)
					
			if(horizontal_collision_info != null):
				if(get_parent().can_wall_slide()):
					get_parent().set_state("WALL_SLIDING")
					get_parent().set_wall_slide_side(get_parent().get_direction().x)
				else:
					get_parent().set_velocity(Vector2())
					
					get_parent().set_state("FALLING")