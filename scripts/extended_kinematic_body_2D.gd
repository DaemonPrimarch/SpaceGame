extends KinematicBody2D

signal collided(info, moved_object)
signal light_entered(source)
signal light_exited(source)
signal bullet_hit(bullet)
signal flippedH()
signal flippedV()

export var max_slope_angle = PI/4

export var flippedH = false setget set_flippedH, is_flippedH
export var flippedV = false setget set_flippedV, is_flippedV

export var moveable_by_collision = true setget set_moveable_by_collision, is_moveable_by_collision

func _ready():
	add_to_group("extended_kinematic_body_2D")
	add_to_group("light_detecting")
	add_to_group("bullet_detecting")

func set_moveable_by_collision(val):
	moveable_by_collision = val

func is_moveable_by_collision():
	return moveable_by_collision

func is_flippedH():
	return flippedH

func is_flippedV():
	return flippedV

func set_flippedH(val):
	if(val != is_flippedH()):
		for child in get_children():
			if(child is Node2D and not child.is_in_group("no_flip")):
				child.set_scale(child.get_scale() * Vector2(-1,1))
				child.set_position(child.get_position() * Vector2(-1,1))
				child.set_rotation(-child.get_rotation())
	
	flippedH = val
	
	emit_signal("flippedH")

func set_flippedV(val):
	if(val != is_flippedV()):
		for child in get_children():
			if(child is Node2D and not child.is_in_group("no_flip")):
				child.set_scale(child.get_scale() * Vector2(1,-1))
				child.set_position(child.get_position() * Vector2(1,-1))
	
	flippedV = val
	
	emit_signal("flippedV")

func get_direction():
	var dir = Vector2(1,1)
	
	if(is_flippedH()):
		dir.x = -1
	if(is_flippedV()):
		dir.y = -1
	
	return dir

func get_max_slope_angle():
	return max_slope_angle


func move_no_collision(v):
	position += v

func move_and_collide(v):
	var prev_pos = position
	
	var collision_info = .move_and_collide(v)
	
	if(collision_info != null):
		if(not is_moveable_by_collision()):
			position = prev_pos + v
			
		
		emit_signal("collided", collision_info, self)
		if(collision_info.collider is load("res://scripts/extended_kinematic_body_2D.gd")):
			collision_info.collider.emit_signal("collided", collision_info, self)
		
	return collision_info
	
func move_and_collide_slope(v):
	var collision_info = move_and_collide(v)
	

	if(collision_info != null and abs(collision_info.normal.rotated(PI/2).angle()) < max_slope_angle and abs(collision_info.normal.rotated(PI/2).angle()) > 0):
		if(has_node("debuggyboy")):
			get_node("debuggyboy").set_cast_to(collision_info.normal.rotated(PI/2) * 10000)
		
		collision_info = move_and_collide(collision_info.remainder.dot(collision_info.normal.rotated(PI/2)) * collision_info.normal.rotated(PI/2)) 
		
		
	return collision_info

func move_and_push(v):	
	var collision_info = move_and_collide(v)
		
	if(collision_info):
		if(collision_info.collider.has_method('push')):
			collision_info.collider.push(collision_info.remainder)
		else:
			print("ERROR: Attempting to push object that can't be pushed")
		
#		if(not is_moveable_by_collision()):
#			position += collision_info.remainder
	