extends "weapon.gd"

var bullet_speed = 1500 setget set_bullet_speed,get_bullet_speed

onready var front = get_node("front")
onready var down = get_node("down")
onready var up = get_node("up")
onready var full_down = get_node("full_down")
onready var full_up = get_node("full_up")
onready var barrel = get_node("barrel")

var current_pos

func _ready():
	current_pos = front
	set_process(true)

func _process(delta):
	if(Input.is_action_pressed("aim_full_up")):
		set_current_pos(full_up)
	elif(Input.is_action_pressed("aim_up")):
		set_current_pos(up)
	elif(Input.is_action_pressed("aim_down")):
		set_current_pos(down)
	elif(Input.is_action_pressed("aim_full_down")):
		set_current_pos(full_down)
	else:
		set_current_pos(front)

func get_current_pos():
	return current_pos
	
func set_current_pos(pos):
	current_pos = pos
	barrel.set_global_pos(pos.get_global_pos())
	barrel.set_rot(pos.get_rot())

func get_bullet_speed():
	return bullet_speed

func set_bullet_speed(value):
	bullet_speed = value

var bullet_count = 0

func press_trigger():
	var bullet = preload("res://nodes/bullet.tscn")
	var instanced_bullet = bullet.instance()
		
	get_tree().get_root().add_child(instanced_bullet)
		
	instanced_bullet.set_pos(get_current_pos().get_global_pos())
	
	var dir = 1
	if(get_scale().x < 0):
		dir = -1
	
	instanced_bullet.set_linear_velocity(Vector2(cos(get_current_pos().get_global_rot()), -sin(get_current_pos().get_global_rot())) * get_bullet_speed() * dir)
	instanced_bullet.add_collision_exception_with(get_parent())