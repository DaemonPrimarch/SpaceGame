extends "res://scripts/enemies/enemy_scrub.gd"

export var push_time = 5 setget set_push_time, get_push_time
export var push_time_extended = 5 setget set_push_time_extended, get_push_time_extended
export var push_speed_x = 4*64 setget set_push_speed_x, get_push_speed_x
export var push_speed_y = 2*64 setget set_push_speed_y, get_push_speed_y

func set_push_speed_x(value):
	push_speed_x = value

func get_push_speed_x():
	return push_speed_x

func set_push_speed_y(value):
	push_speed_y = -value

func get_push_speed_y():
	return push_speed_y

func set_push_time(value):
	push_time = value

func get_push_time():
	return push_time

func set_push_time_extended(value):
	push_time_extended = value

func get_push_time_extended():
	return push_time_extended


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func on_bullet_hit(bullet):
	pass

func on_collision_with_player(collision_info):
	.on_collision_with_player(collision_info)
	if(collision_info.get_collider().is_in_group("player")):
		collision_info.get_collider().push(get_push_time(), get_push_time_extended(),Vector2(get_push_speed_x(),get_push_speed_y()))