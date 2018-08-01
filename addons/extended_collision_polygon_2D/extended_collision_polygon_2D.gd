tool
extends CollisionPolygon2D

signal AABB_changed()

func _ready():
	add_to_group("extended_collision_polygon_2D")

func set_polygon(pol):
	.set_polygon(pol)
	
	emit_signal("AABB_changed")

func get_AABB():
	var pol = polygon
	var new_pos = pol[0]
	var max_y = new_pos.y
	var min_y = new_pos.y
	var max_x = new_pos.x
	var min_x = new_pos.x
	
	for element_local in pol:
		var element = element_local
		if(element.y < max_y):
			max_y = element.y
		elif(element.y > min_y):
			min_y = element.y
		if(element.x > max_x):
			max_x = element.x
		if(element.x < min_x):
			min_x = element.x
			
	return Rect2(Vector2(min_x, max_y) + global_position, Vector2(abs(max_x - min_x), abs(max_y - min_y)))