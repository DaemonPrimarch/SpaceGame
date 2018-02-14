extends KinematicBody2D

signal collided(info, moved_object)

export var max_slope_angle = PI/2

func get_max_slope_angle():
	return max_slope_angle

func move_and_collide(v):
	var collision_info = .move_and_collide(v)
	
	if(collision_info != null):
		emit_signal("collided", collision_info, self)
		if(collision_info.collider is load("res://scripts/extended_kinematic_body_2D.gd")):
			collision_info.collider.emit_signal("collided", collision_info, self)
		
	return collision_info
	
func move_and_collide_slope(v):
	var collision_info = move_and_collide(v)

	while(collision_info != null and abs(collision_info.normal.rotated(PI/2).angle()) < max_slope_angle):
		collision_info = move_and_collide(collision_info.remainder.dot(collision_info.normal.rotated(PI/2)) * collision_info.normal.rotated(PI/2))
	return collision_info