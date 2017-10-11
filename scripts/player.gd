
extends "res://scripts/entity.gd"

export var jump_speed = 98 *2 setget set_jump_speed,get_jump_speed
export var climbing_speed = 64 * 3
export var jumping_height = 4 * 64
export var wall_jump_speed = 4*64

var original_gravity_enabled = gravity_enabled

#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = get_node("sprite")

onready var animation_player = get_node("AnimationPlayer")

var animation = "idle"
var shooting = false
var walking = false
var has_jumped = false
var has_double_jumped =false
var is_wall_sliding = false
var is_wall_jumping = false
var wall_left

var moving = false
var moving_up = false

var time_jumping = 0
var jumping = false
var double_jumping = false

var climbing = false

func has_jumped():
	return has_jumped

func has_double_jumped():
	return has_double_jumped

func get_jumping_height():
	return jumping_height

func is_climbing():
	return climbing

func get_starting_jump_velocity():
	return get_gravity_vector()*get_max_jump_time()*-1

func get_wall_jump_velocity():
	if(is_wall_jumping):
		if(wall_left):
			return Vector2(wall_jump_speed,0)
		else:
			return Vector2(-wall_jump_speed,0)
	else:
		return Vector2(0,0)

func get_max_jump_time():

	return sqrt(get_jumping_height()/(get_gravity_vector().y/2))

func set_climbing(val):
	#if(val != is_climbing()):
	
	climbing = val
	set_gravity_enabled(!val)

func get_climbing_speed():
	return climbing_speed

func set_jump_speed(value):
	jump_speed = value

func get_jump_speed():
	return jump_speed

func _ready():
	set_fixed_process(true)

func is_jumping():
	return jumping

func is_double_jumping():
	return double_jumping

func start_jump():
	has_jumped = true
	original_gravity_enabled = gravity_enabled
	set_gravity_enabled(false)
	jumping = true
	time_jumping = 0

func start_double_jump():
	has_double_jumped = true
	original_gravity_enabled = gravity_enabled
	set_gravity_enabled(false)
	double_jumping = true
	time_jumping = 0

func start_wall_jump():
	set_flippedH(!is_flippedH())
	has_jumped = true
	original_gravity_enabled = gravity_enabled
	set_gravity_enabled(false)
	jumping = true
	is_wall_jumping = true
	is_wall_sliding = false
	time_jumping = 0

func stop_jump():
	set_gravity_enabled(original_gravity_enabled)
	jumping = false
	is_wall_jumping =false

func stop_double_jump():
	set_gravity_enabled(original_gravity_enabled)
	double_jumping = false

func _fixed_process(delta):	
	if(is_on_ground()):
		if (has_jumped()):
			has_jumped = false
			has_double_jumped = false
		elif(is_wall_sliding):
			is_wall_sliding = false
	var new_animation = "idle"
	
	if(Input.is_action_pressed("set_climb_on")):
		set_climbing(true)
	elif(Input.is_action_pressed("set_climb_off")):
		set_climbing(false)
	
	if(is_climbing()):
		if(Input.is_action_pressed("up")):
			move(Vector2(0, -get_climbing_speed() * delta))
		elif(Input.is_action_pressed("down")):
			move(Vector2(0, get_climbing_speed() * delta))
		if(Input.is_action_pressed("play_left")):
			move(Vector2(-get_climbing_speed() * delta, 0))
		elif(Input.is_action_pressed("play_right")):
			move(Vector2(get_climbing_speed() * delta, 0))
	else:
		if(Input.is_action_pressed("jump")):
			if(not is_jumping() and not is_double_jumping()):
				if(is_on_ground()):
					start_jump()
				elif(is_wall_sliding):
					start_wall_jump()
				elif(has_jumped and not has_double_jumped):
					start_double_jump()
			
			if(is_jumping()):
				new_animation = "jumping"
				move((get_wall_jump_velocity()+get_starting_jump_velocity()+get_gravity_vector()*time_jumping)*delta)
				time_jumping += delta
				
				if(time_jumping >= get_max_jump_time()):
					stop_jump()
			elif(is_double_jumping()):
				new_animation = "jumping"
				move((get_starting_jump_velocity()+get_gravity_vector()*time_jumping)*delta)
				time_jumping += delta
				
				if(time_jumping >= get_max_jump_time()):
					stop_double_jump()
		elif(is_jumping()):
			stop_jump()
		elif(is_double_jumping()):
			stop_double_jump()
			
		if((not is_on_ground())and (not is_jumping())):
			new_animation = "falling"
		
		if(Input.is_action_pressed("play_left") and not is_warping() and not is_wall_jumping):
			set_flippedH(true)
			var collision_info = move(Vector2(- get_movement_speed() * delta, 0))
			if(collision_info.has_collision() and collision_info.get_collider().is_in_group("terrain") and not is_on_ground()):
				is_wall_sliding = true
				wall_left = true
			else:
				is_wall_sliding = false
			if(is_on_ground()):
				new_animation = "run"
		elif(Input.is_action_pressed("play_right") and not is_warping() and not is_wall_jumping):
			set_flippedH(false)
			var collision_info = move(Vector2(get_movement_speed() * delta, 0))
			if(collision_info.has_collision() and collision_info.get_collider().is_in_group("terrain") and not is_on_ground()):
				is_wall_sliding = true
				wall_left = false
			else:
				is_wall_sliding = false
			if(is_on_ground()):
				new_animation = "run"
		if(Input.is_action_pressed("shoot")):
			if(new_animation == "falling"):
				new_animation = "falling_weapon"
			elif(new_animation == "jumping"):
				new_animation = "jumping_weapon"
			elif(new_animation == "run"):
				new_animation = "run_weapon"
			elif(new_animation == "idle"):
				new_animation = "standing_weapon_ready"
		if(is_wall_sliding):
			new_animation = "run"
		if(new_animation != animation):
			animation_player.play(new_animation)
			animation = new_animation
	print(is_jumping())
	

func _on_shoot_countdown_timeout():
	shooting = false
