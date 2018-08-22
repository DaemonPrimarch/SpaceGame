extends "res://addons/state_handler/state_handler.gd"

export var climbing_speed = 64 * 4

enum direction {FACING_SIDEWAYS, FACING_FORWARD}

var facing_direction = direction.FACING_FORWARD

export var cooldown_time = 0.3
var cooldown_timer

func _ready():
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = cooldown_time
	cooldown_timer.one_shot = true
	
	add_child(cooldown_timer)
func get_facing_direction():
	return facing_direction

func set_facing_direction(dir):
	facing_direction = dir
	
	if(dir == direction.FACING_SIDEWAYS):
		$Label.text = "FACING_RIGHT"
	else:
		$Label.text = ""
		
func get_climbing_speed():
	return climbing_speed
	
func set_climbing_speed(speed):
	climbing_speed = speed

var ladder = null

func enter_state(previous_state):
	.enter_state(previous_state)

	get_parent().get_node("weapon_manager").scale *= Vector2(-1,1)

	set_facing_direction(direction.FACING_FORWARD)
	
	ladder = get_parent().get_node("ladder_manager").get_ladder()
	
	ladder.snap_to(get_parent())
	
	get_parent().set_velocity(Vector2())
	
func leave_state(new_state):
	.leave_state(new_state)
	
	get_parent().get_node("weapon_manager").scale *= Vector2(-1,1)
	cooldown_timer.start()

func calculate_facing_direction():
	if(get_parent().is_action_pressed("play_left")):
		set_facing_direction(direction.FACING_SIDEWAYS)
	elif(get_parent().is_action_pressed("play_right")):
		set_facing_direction(direction.FACING_SIDEWAYS)
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
	return .can_enter() and cooldown_timer.is_stopped() and get_parent().get_node("ladder_manager").is_inside_ladder() and get_parent().get_node("ladder_manager").get_ladder().is_in_group("walled_ladder")
