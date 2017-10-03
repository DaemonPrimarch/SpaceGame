
extends "res://scripts/entity.gd"

export var jump_speed = 98 *2 setget set_jump_speed,get_jump_speed
export var max_jump_time = 2
export var climbing_speed = 64 * 3

var original_gravity_enabled = gravity_enabled

#cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = get_node("sprite")

onready var animation_player = get_node("AnimationPlayer")

var animation = "idle"
var shooting = false
var walking = false

var moving = false
var moving_up = false

var time_jumping = 0
var jumping = false

var climbing = false

func is_climbing():
	return climbing

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
	
func start_jump():
	original_gravity_enabled = gravity_enabled
	set_gravity_enabled(false)
	jumping = true
	time_jumping = 0

func stop_jump():
	set_gravity_enabled(original_gravity_enabled)
	jumping = false

func _fixed_process(delta):	
	var new_animation = "idle"
	
	if(Input.is_action_pressed("set_climb_on")):
		set_climbing(true)
	elif(Input.is_action_pressed("set_climb_off")):
		print("HELLO?")
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
			if(not is_jumping() and is_on_ground()):
				start_jump()
			
			if(is_jumping()):
				new_animation = "jumping"
				move(Vector2(0, -get_jump_speed() * delta))
				time_jumping += delta
				
				if(time_jumping >= max_jump_time):
					stop_jump()
		elif(is_jumping()):
			stop_jump()
			
		if((not is_on_ground())and (not is_jumping())):
			new_animation = "falling"
		
		if(Input.is_action_pressed("play_left") and not is_warping()):
			set_flippedH(true)
			move(Vector2(- get_movement_speed() * delta, 0))
			
			if(is_on_ground()):
				new_animation = "run"
		elif(Input.is_action_pressed("play_right") and not is_warping()):
			set_flippedH(false)
			move(Vector2(get_movement_speed() * delta, 0))
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
		
		if(new_animation != animation):
			animation_player.play(new_animation)
			animation = new_animation
	

func _on_shoot_countdown_timeout():
	shooting = false
