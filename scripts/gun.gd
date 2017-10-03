extends "weapon.gd"

var bullet_speed = 1500 setget set_bullet_speed,get_bullet_speed

func _ready():
	pass

func get_bullet_speed():
	return bullet_speed

func set_bullet_speed(value):
	bullet_speed = value

func press_trigger():
	var bullet = preload("res://nodes/bullet.tscn")
	var instanced_bullet = bullet.instance()
		
	get_tree().get_root().add_child(instanced_bullet)
		
	instanced_bullet.set_pos(get_global_pos())
	
	instanced_bullet.set_linear_velocity(Vector2(get_bullet_speed(), 0) * get_scale().normalized())
	instanced_bullet.add_collision_exception_with(get_parent()) 