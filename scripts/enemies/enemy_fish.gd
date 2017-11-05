extends "res://scripts/enemies/enemy.gd"

onready var timer = get_node("swim_timer")
export var jump_height = 2*64
export var jump_length = 2*64
export var stationary = false
export var right = true
var swims_right
var current_state
var time_jumping = 0

enum STATE {SWIMMING, JUMPING, IDLE}

export var push_time = 5 setget set_push_time, get_push_time
export var push_time_extended = 5 setget set_push_time_extended, get_push_time_extended
export var push_speed = Vector2(4*64, -4*64) setget set_push_speed, get_push_speed

func set_push_speed(value):
	push_speed = value

func get_push_speed():
	return push_speed

func set_push_time(value):
	push_time = value

func get_push_time():
	return push_time

func set_push_time_extended(value):
	push_time_extended = value

func get_push_time_extended():
	return push_time_extended

func get_jumping_velocity():
	var jump_time = sqrt(jump_height / (get_gravity_vector().y/2))
	return Vector2(0, -jump_time * get_gravity_vector().y)

func get_swimming_velocity():
	return Vector2(swims_right * get_movement_speed(),0)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	if(right):
		swims_right = 1
	else:
		swims_right = -1
	if(stationary):
		current_state = STATE.IDLE
	else:
		current_state = STATE.SWIMMING
	timer.set_wait_time(float(jump_length) / get_movement_speed())
	timer.start()
	set_fixed_process(true)

func _fixed_process(delta):
	if(current_state == STATE.SWIMMING):
		move(get_swimming_velocity()*delta)
	elif(current_state == STATE.JUMPING):
		move((get_jumping_velocity() + time_jumping*get_gravity_vector())*delta)
		time_jumping += delta
		if(get_pos().y >= 0):
			if(stationary):
				enter_state(STATE.IDLE)
			else:
				enter_state(STATE.SWIMMING)

func enter_state(state):
	current_state = state
	leave_state(current_state)
	if(state == STATE.SWIMMING):
		timer.start()
	elif(state == STATE.JUMPING):
		time_jumping = 0
	elif(state == STATE.IDLE):
		timer.start()

func leave_state(state):
	if(state == STATE.SWIMMING):
		pass
	elif(state == STATE.JUMPING):
		pass
	elif(state == STATE.IDLE):
		pass


func _on_swim_timer_timeout():
	timer.stop()
	enter_state(STATE.JUMPING)

func on_collision_with_player(collision_info):
	.on_collision_with_player(collision_info)
	if(collision_info.get_collider().is_in_group("player")):
		collision_info.get_collider().push(get_push_time(), get_push_time_extended(),get_push_speed())
