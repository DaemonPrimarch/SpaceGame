extends Node

func polygon_to_AABB(shape):
	var aabb = Rect2()
	
	aabb.pos = shape.get_points()[0]
	aabb.end = shape.get_points()[0]
	
	var min_x = shape.get_points()[0].x
	var max_x = shape.get_points()[0].x
	var min_y =  shape.get_points()[0].y
	var max_y =  shape.get_points()[0].y
	
	for point in shape.get_points():
		if(point.x < min_x):
			min_x= point.x
		if(point.y < min_y):
			min_y = point.y
		if(point.x > max_x):
			max_x = point.x
		if(point.y > max_y):
			max_y= point.y
	
	var start = Vector2(min_x, min_y)
	var stop = Vector2(max_x, max_y)
	
	return Rect2(start, stop - start)