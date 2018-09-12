extends Node2D

export (PackedScene) var bullet_type = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func shoot():
	var bullet = bullet_type.instance()
	
	var room = ROOM_MANAGER.get_room_of_node(self)
	
	bullet.set_position(room.to_local(to_global($bullet_spawn_position.position)))
	
	bullet.set_velocity(bullet.get_velocity())
	
	var bullet_rotation = $bullet_spawn_position.rotation
	
	if(PHYSICS_HELPER.get_global_scale_of_node(self).x <0):
		bullet.set_rotation(PI - bullet_rotation)
	else:
		bullet.set_rotation(bullet_rotation)
	
	room.add_child(bullet)
	
	return bullet
