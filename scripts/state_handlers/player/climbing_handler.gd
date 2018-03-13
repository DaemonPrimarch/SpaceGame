extends "res://scripts/state_handler.gd"

export var climbing_speed = 64 * 4

var is_inside_same_ladder = false

func get_climbing_speed():
	return climbing_speed
	
func set_climbing_speed(speed):
	climbing_speed = speed

func _ready():
	set_no_gravity(true)

func get_handled_state():
	return "CLIMBING"

func enter_state(previous_state):
	.enter_state(previous_state)
	
	get_parent().get_ladder().snap_to(get_parent())
	
	is_inside_same_ladder = true
	get_parent().get_ladder().get_node("Area2D").connect("body_exited", self, "ladder_left")
	
	if(get_parent().get_ladder().is_flippedH()):
		if(not get_parent().is_flippedH()):
			get_parent().set_flippedH(true)
	else:
		if(get_parent().is_flippedH()):
			get_parent().set_flippedH(false)
	
	get_parent().get_node("weapon_manager").scale *= Vector2(-1,1)
	
	get_parent().set_velocity(Vector2())
	
func leave_state(new_state):
	.leave_state(new_state)
	
	get_parent().get_node("weapon_manager").scale *= Vector2(-1,1)
	
func process_state(delta):
	.process_state(delta)
	
	if(Input.is_action_just_pressed("jump")):
		get_parent().set_state("WALL_JUMPING")
	elif(not get_parent().is_inside_ladder()):
		get_parent().set_state("FALLING")
	else:
		var dir = 0
				
		if(Input.is_action_pressed("play_up")):
			if(not top_reached() or get_parent().get_ladder().is_in_group("top")):
				dir = -1
		elif(Input.is_action_pressed("play_down")):
			dir = 1
			
		if(get_parent().move_and_collide(Vector2(0, dir) * get_climbing_speed() * delta) != null):
			get_parent().set_state("STANDING")

func top_reached():
	if( get_parent().global_position.y - get_parent().get_AABB().size.y + get_parent().get_AABB().position.y < get_parent().get_ladder().global_position.y - 32):
		return true
	else:
		return false

func can_enter():
	return .can_enter() and not is_inside_same_ladder

func ladder_left(body):
	is_inside_same_ladder = false
	get_parent().get_ladder().get_node("Area2D").disconnect("body_exited", self, "ladder_left")