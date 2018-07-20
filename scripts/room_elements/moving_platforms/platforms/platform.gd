tool
extends "res://addons/extended_kinematic_body_2D/extended_kinematic_body_2D.gd"

signal extending_direction_changed()

export var extending_vertical = true setget set_extending_vertical, is_extending_vertical

func set_extending_vertical(val):
	extending_vertical = val
	
	emit_signal("extending_direction_changed")

func is_extending_vertical():
	return extending_vertical

#export var extended_distance = 0 setget set_extended_distance, get_extended_distance
var extended_distance = 0

var rect_size
var rect_pos

func _ready():
	rect_size = $TemporarySprite.rect_size
	rect_pos = $TemporarySprite.rect_position
	
func set_flippedH(val):
	.set_flippedH(val)
	
	emit_signal("extending_direction_changed")
	
func set_flippedV(val):
	.set_flippedV(val)

	emit_signal("extending_direction_changed")
	
func get_extending_direction():
	var dir = Vector2(1,0)
	
	if(is_extending_vertical()):
		dir = Vector2(0,-1)
	
	dir *= get_direction()
	
	return dir

func set_extended_distance(val):
	if(is_inside_tree()):
		extend(val - get_extended_distance())
	else:
		extended_distance = val

func get_extended_distance():
	return extended_distance

func extend(val):
	if(not is_extending_vertical()):
		$CollisionPolygon2D.polygon[0].x += val
		$CollisionPolygon2D.polygon[3].x += val
		
		rect_size.x += val
	else:
		$CollisionPolygon2D.polygon[0].y -= val
		$CollisionPolygon2D.polygon[1].y -= val
		
		rect_size.y += val
		
	$TemporarySprite.rect_size = rect_size
		
	if((is_extending_vertical() and not is_flippedV())):
		rect_pos.y -= val
	elif((not is_extending_vertical() and is_flippedH())):
		rect_pos.x -= val
	
	$TemporarySprite.rect_position = rect_pos
	
	extended_distance += val
