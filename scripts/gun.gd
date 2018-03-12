extends "res://scripts/weapon.gd"


func press_trigger():
	var bullet = preload("res://nodes/weapons/bullet.tscn").instance()
	
	var room = ROOM_MANAGER.get_room_of_node(self)
	
	bullet.set_position(room.to_local(to_global(Vector2(40, 0))))
	
	bullet.set_velocity(Vector2(64 * 16, 0))
	if(PHYSICS_HELPER.get_global_scale_of_node(self).x <0):
		bullet.set_rotation(PI - rotation)
	else:
		bullet.set_rotation(rotation)
	
	room.add_child(bullet)


	#HAX https://github.com/godotengine/godot/issues/17405