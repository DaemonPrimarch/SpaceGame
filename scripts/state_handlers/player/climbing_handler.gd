extends "res://addons/state_handler/state_handler.gd"

export var climbing_speed = 64 * 4

enum direction {FACING_LEFT, FACING_RIGHT, FACING_FORWARD}

var is_inside_same_ladder = false

var facing_direction = direction.FACING_FORWARD

var ladder = null

func get_facing_direction():
	return facing_direction

func set_facing_direction(dir):
	facing_direction = dir
	
	if(dir == direction.FACING_LEFT):
		$Label.text = "FACING_LEFT"
	elif(dir == direction.FACING_RIGHT):
		$Label.text = "FACING_RIGHT"
	else:
		$Label.text = ""
		
func get_climbing_speed():
	return climbing_speed
	
func set_climbing_speed(speed):
	climbing_speed = speed

func _ready():
	set_no_gravity(true)

func enter_state(previous_state):
	.enter_state(previous_state)

	set_facing_direction(direction.FACING_FORWARD)
	
	ladder = get_parent().get_node("ladder_manager").get_ladder()
	
	ladder.snap_to(get_parent())
	
	is_inside_same_ladder = true
	
	ladder.get_node("Area2D").connect("body_exited", self, "ladder_left", [ladder])
	
	if(ladder.is_flippedH()):
		if(not get_parent().is_flippedH()):
			get_parent().set_flippedH(true)
	else:
		if(get_parent().is_flippedH()):
			get_parent().set_flippedH(false)
	
	get_parent().get_node("weapon_manager").scale *= Vector2(-1,1)
	
	get_parent().set_velocity(Vector2())
	
func leave_state(new_state):
	.leave_state(new_state)
	
	ladder.get_node("Area2D").disconnect("body_exited", self, "ladder_left")
	
	get_parent().get_node("weapon_manager").scale *= Vector2(-1,1)

func calculate_facing_direction():
	if(get_parent().is_action_pressed("play_left")):
		set_facing_direction(direction.FACING_LEFT)
	elif(get_parent().is_action_pressed("play_right")):
		set_facing_direction(direction.FACING_RIGHT)
	else:
		set_facing_direction(direction.FACING_FORWARD)

func process_state(delta):
	.process_state(delta)
	
	calculate_facing_direction()
	if(not get_parent().get_node("ladder_manager").is_inside_ladder()):
		get_parent().set_state("FALLING")
	elif(get_facing_direction() == direction.FACING_FORWARD):
		if(get_parent().is_action_just_pressed("jump")):
			get_parent().set_state("FALLING")
		else:
			var dir = 0
			if(get_parent().is_action_pressed("play_up")):
				if(not top_reached() or ladder.is_in_group("top")):
					dir = -1
			elif(get_parent().is_action_pressed("play_down")):
				dir = 1
				
			if(get_parent().move_and_collide(Vector2(0, dir) * get_climbing_speed() * delta) != null):
				get_parent().set_state("STANDING")
	elif(get_parent().is_action_just_pressed("jump")):
		get_parent().set_state("WALL_JUMPING")

func top_reached():
	if(get_parent().global_position.y - get_parent().get_AABB().size.y + get_parent().get_AABB().position.y < ladder.global_position.y - 32):
		return true
	else:
		return false

func can_enter():
	return .can_enter() and get_parent().get_node("ladder_manager").is_inside_ladder() and not (is_inside_same_ladder and ladder.is_in_group("walled_ladder"))

func ladder_left(body,ladder):
	is_inside_same_ladder = false
	
	ladder.get_node("Area2D").disconnect("body_exited", self, "ladder_left")