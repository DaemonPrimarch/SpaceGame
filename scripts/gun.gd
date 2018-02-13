extends "res://scripts/weapon.gd"


func press_trigger():
	var bullet = preload("res://nodes/weapons/bullet.tscn").instance()
	
	var room = ROOM_MANAGER.get_room_of_node(self)
	
	bullet.set_position(room.to_local(to_global(Vector2(40, 0))))
	bullet.set_velocity(get_scale()/get_scale().abs() * Vector2(64 * 4, 0))
	bullet.set_rotation(get_rotation())
	
	room.add_child(bullet)
