extends "weapon.gd"

func _ready():
	pass

func press_trigger():
	var bullet = preload("res://nodes/bullet.tscn")
	var instanced_bullet = bullet.instance()
		
	get_tree().get_root().add_child(instanced_bullet)
		
	instanced_bullet.set_pos(get_global_pos())
	
	instanced_bullet.set_linear_velocity(Vector2(400, 0) * get_scale().normalized())
	instanced_bullet.add_collision_exception_with(get_parent()) 