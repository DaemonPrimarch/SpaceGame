extends "res://addons/extended_kinematic_body_2D/extended_kinematic_body_2D.gd"

var rect_size
var rect_pos

func _ready():
	rect_size = $TemporarySprite.rect_size
	rect_pos = $TemporarySprite.rect_position

func extend(v):
	if(v.x != 0):
		$CollisionPolygon2D.polygon[0] += v
		$CollisionPolygon2D.polygon[3] += v
	if(v.y != 0):
		$CollisionPolygon2D.polygon[0] -= v
		$CollisionPolygon2D.polygon[1] -= v
	
	rect_size += v
	
	$TemporarySprite.rect_size = rect_size
	if((v.x != 0 and is_flippedH()) or (v.y != 0 and not is_flippedV())):
		rect_pos -= v
		$TemporarySprite.rect_position = rect_pos
		