extends "res://scripts/weapon.gd"


func press_trigger():
	var bullet = preload("res://nodes/weapons/bullet.tscn").instance()
	
	var room = ROOM_MANAGER.get_room_of_node(self)
	
	bullet.set_position(room.to_local(to_global(Vector2(40, 0))))
	
	bullet.set_velocity((global_scale/global_scale.abs()) * Vector2(64 * 16, 0))
	bullet.set_rotation(global_rotation * global_scale.y)
	
	room.add_child(bullet)


	#HAX https://github.com/godotengine/godot/issues/17405