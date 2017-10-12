extends "weapon.gd"

var bullet_speed = 1500 setget set_bullet_speed,get_bullet_speed
onready var starting_pos = Vector2(0,0) setget set_starting_pos,get_starting_pos
export var radius = 32 setget set_radius,get_radius
var current_state

enum STATE {AIM_FULL_UP, AIM_UP, AIM_DOWN, NORMAL}

func _ready():
	current_state = STATE.NORMAL
	set_process_input(true)

func get_bullet_speed():
	return bullet_speed

func set_bullet_speed(value):
	bullet_speed = value

func set_starting_pos(vector):
	starting_pos = vector

func get_starting_pos():
	return starting_pos

func set_radius(value):
	radius = value

func get_radius():
	return radius

func press_trigger():
	var bullet = preload("res://nodes/bullet.tscn")
	var instanced_bullet = bullet.instance()
		
	get_tree().get_root().add_child(instanced_bullet)
		
	instanced_bullet.set_pos(get_global_pos())
	if(get_parent().is_flippedH()):
		instanced_bullet.set_linear_velocity(-1*Vector2(get_bullet_speed()*cos(get_rot()), get_bullet_speed()*-sin(get_rot())))
	else:
		instanced_bullet.set_linear_velocity(Vector2(get_bullet_speed()*cos(get_rot()), get_bullet_speed()*-sin(get_rot())))
		instanced_bullet.add_collision_exception_with(get_parent()) 

func enter_state(state):
	if(state == STATE.NORMAL):
		if(get_parent().is_flippedH()):
			set_rot(0)
		else:
			set_rot(0)
		set_pos(Vector2(23.958525,-12.732317)  * get_scale().normalized())
	elif(state == STATE.AIM_FULL_UP):
		if(get_parent().is_flippedH()):
			set_rot(-PI/2)
		else:
			set_rot(PI/2)
		set_pos(Vector2(-4.186637,-46.238438) * get_scale().normalized())
	elif(state == STATE.AIM_UP):
		if(get_parent().is_flippedH()):
			set_rot(-PI/4)
		else:
			set_rot(PI/4)
		set_pos(Vector2(20.607908,-28.815247) * get_scale().normalized())
	elif(state == STATE.AIM_DOWN):
		if(get_parent().is_flippedH()):
			set_rot(PI/4)
		else:
			set_rot(-PI/4)
		set_pos(Vector2(20.607906,-4.690836) * get_scale().normalized())

func _input(ev):
	if(current_state == STATE.NORMAL):
		if(ev.is_action_pressed("aim_full_up")):
			enter_state(STATE.AIM_FULL_UP)
		elif(ev.is_action_pressed("aim_up")):
			enter_state(STATE.AIM_UP)
		elif(ev.is_action_pressed("aim_down")):
			enter_state(STATE.AIM_DOWN)
	
	if(ev.is_action_released("aim_full_up")):
		enter_state(STATE.NORMAL)
	if(ev.is_action_released("aim_up")):
		enter_state(STATE.NORMAL)
	if(ev.is_action_released("aim_down")):
		enter_state(STATE.NORMAL)