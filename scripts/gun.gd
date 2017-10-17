extends "weapon.gd"

export var bullet_speed = 1500 setget set_bullet_speed,get_bullet_speed
var bullet_count = 0

func get_bullet_speed():
	return bullet_speed

func set_bullet_speed(value):
	bullet_speed = value

func on_trigger_press():
	var bullet = preload("res://nodes/bullet.tscn")
	var instanced_bullet = bullet.instance()
	
	get_parent().get_parent().add_child(instanced_bullet)
	
	instanced_bullet.set_pos(get_current_point().get_global_pos())
	
	var dir = 1
	if(get_scale().x < 0):
		dir = -1
	
	instanced_bullet.set_linear_velocity(Vector2(cos(get_current_point().get_global_rot()), -sin(get_current_point().get_global_rot())) * get_bullet_speed() * dir)
	instanced_bullet.add_collision_exception_with(get_parent())