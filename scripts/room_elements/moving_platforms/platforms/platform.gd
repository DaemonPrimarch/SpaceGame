tool

extends "res://scripts/extended_kinematic_body_2D.gd"

export var extending = false

func is_extending():
	return extending
	
func move_and_push(v):
	.move_and_push(v)
	
	if(is_extending()):
		extend(v)

func extend(v):
	var platform_polygon = get_node("CollisionPolygon2D").polygon
	
	if(v.x != 0):		
		if(is_flippedH()):
			get_node("Panel").margin_right -= v.x

			platform_polygon[1] += Vector2(v.x,0)
			platform_polygon[2] += Vector2(v.x,0)
		else:
			get_node("Panel").margin_left -= v.x
			
			platform_polygon[1] -= Vector2(v.x,0)
			platform_polygon[2] -= Vector2(v.x,0)
			
	if(v.y != 0):		
		if(not is_flippedV()):
			get_node("Panel").margin_bottom -= v.y
				
			platform_polygon[2] -= Vector2(0,v.y)
			platform_polygon[3] -= Vector2(0,v.y)
		else:
			get_node("Panel").margin_top -= v.y
				
			platform_polygon[2] += Vector2(0,v.y)
			platform_polygon[3] += Vector2(0,v.y)

	get_node("CollisionPolygon2D").polygon = platform_polygon