extends "res://scripts/state_handler.gd"

export var jump_height = 64 * 4.2 setget set_jump_height, get_jump_height

func _ready():
	set_no_gravity(true)

func get_jump_height():
	return jump_height

func set_jump_height(val):
	jump_height = val

func get_handled_state():
	return "REGULAR_JUMPING"
	
func enter_state(previous_state):
	.enter_state(previous_state)
			
	get_parent().set_velocity(Vector2(0,1) * get_parent().calculate_starting_velocity_y(get_jump_height(), get_parent().get_gravity_vector().y))
			
	get_parent().animation_player.play("jump")
	
func process_state(delta):
	.process_state(delta)
	
	if(not Input.is_action_pressed("jump") or get_timer() > get_parent().calculate_max_airtime(get_jump_height(), get_parent().get_gravity_vector().y)):
		get_parent().set_velocity(Vector2(get_parent().get_velocity().x,0))
		get_parent().set_state("FALLING")
	elif(Input.is_action_pressed("play_up") and get_parent().is_inside_ladder()):
		get_parent().set_state("CLIMBING")
	else:
		get_parent().set_velocity(get_parent().get_velocity() + get_parent().get_gravity_vector() * delta)
				
		var vertical_collision_info  = get_parent().move_and_collide(get_parent().get_velocity() * delta)
		
		if (vertical_collision_info != null):
			get_parent().set_velocity(Vector2(get_parent().get_velocity().x,0))
			get_parent().set_state("FALLING")
		
		else:
			var pressed = 0
					
			if(Input.is_action_pressed("play_left")):
				get_parent().set_flippedH(true)
				pressed = 1
			elif(Input.is_action_pressed("play_right")):
				get_parent().set_flippedH(false)
				pressed = 1
						
			var horizontal_collision_info = get_parent().move_and_collide(Vector2(1,0) * get_parent().get_direction() * pressed * delta * get_parent().get_movement_speed())
					
			if(horizontal_collision_info != null and get_parent().can_wall_slide()):
				get_parent().set_state("WALL_SLIDING")
				get_parent().set_wall_slide_side(get_parent().get_direction().x)