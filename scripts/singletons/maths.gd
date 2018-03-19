extends Node

const epsilon = 10

func min_arr(array):
	var min_val = array[0]

	for val in array:
		min_val = min(min_val, val)

	return min_val

func max_arr(array):
	var max_val = array[0]

	for val in array:
		max_val = min(max_val, val)

	return max_val

func cross(v1, v2):
	return v1.x * v2.y - v1.y * v2.x
#
func is_zero(a):
	return abs(a) < epsilon
	

#https://stackoverflow.com/questions/217578/how-can-i-determine-whether-a-2d-point-is-within-a-polygon/2922778#2922778	
	
func is_point_in_polygon(point, polygon):
	var isInside = false;
	var minX = polygon[0].x
	var maxX = polygon[0].x
	var minY = polygon[0].y
	var maxY = polygon[0].y

	for p in polygon:
		minX = min(p.x, minX);
		maxX = max(p.x, maxX);
		minY = min(p.y, minY);
		maxY = max(p.y, maxY);

	if (point.x < minX || point.x > maxX || point.y < minY || point.y > maxY):
		return false;

	for i in range(polygon.size()):
		var p1 = polygon[i]
		var p2 = polygon[(i + 1)%polygon.size()]
		
		if ( (p1.y > point.y) != (p2.y > point.y) && point.x < (p2.x - p1.x) * (point.y - p1.y) / (p2.y - p1.y) + p1.x ):
			isInside = !isInside

	return isInside;

func offset_point_polygon(point, polygon):
	#https://stackoverflow.com/questions/10983872/distance-from-a-point-to-a-polygon
	# https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
	var minDist = 1000000
	var offset = Vector2()
	
	for i in range(polygon.size()):
		var p1 = polygon[i]
		var p2 = polygon[(i + 1)%polygon.size()]
		
		var A = point.x - p1.x;
		var B = point.y - p1.y;
		var C = p2.x - p1.x;
		var D = p2.y - p1.y;

		var dot = A * C + B * D;
		var len_sq = C * C + D * D;
		var param = -1;
		if (len_sq != 0):
			param = dot / len_sq;

		var xx
		var yy

		if (param < 0):
			xx = p1.x;
			yy = p1.y;
		elif (param > 1):
			xx = p2.x;
			yy = p2.y;
		else:
			xx = p1.x + param * C;
			yy = p1.y + param * D;
		var dx = point.x - xx
		var dy = point.y - yy;
		
		if(sqrt(dx * dx + dy * dy) < minDist):
			minDist = sqrt(dx * dx + dy * dy)
			
			offset = Vector2(dx, dy)
		
	return offset
	
func offset_rect_polygon(rect, polygon):
	var offset = Vector2()

	
	var bottom_right = rect.position + rect.size
	var bottom_left = rect.position + rect.size * Vector2(0, 1)
	var top_right = rect.position + rect.size * Vector2(1, 0)
	var top_left = rect.position
						
	if(not is_point_in_polygon(top_left, polygon)):
		var new_offset = offset_point_polygon(top_left, polygon)
						
		if(abs(offset.x) < abs(new_offset.x)):
			offset.x = new_offset.x
		if(abs(offset.y) < abs(new_offset.y)):
			offset.y = new_offset.y
	if(not is_point_in_polygon(top_right, polygon)):
		var new_offset = offset_point_polygon(top_right, polygon)
						
		if(abs(offset.x) < abs(new_offset.x)):
			offset.x = new_offset.x
		if(abs(offset.y) < abs(new_offset.y)):
			offset.y = new_offset.y
	if(not is_point_in_polygon(bottom_left, polygon)):
		var new_offset = offset_point_polygon(bottom_left, polygon)
						
		if(abs(offset.x) < abs(new_offset.x)):
			offset.x = new_offset.x
		if(abs(offset.y) < abs(new_offset.y)):
			offset.y = new_offset.y
	if(not is_point_in_polygon((bottom_right),polygon)):
		var new_offset = offset_point_polygon(bottom_right, polygon)
						
		if(abs(offset.x) < abs(new_offset.x)):
			offset.x = new_offset.x
		if(abs(offset.y) < abs(new_offset.y)):
			offset.y = new_offset.y	
	return offset
func get_aabb_of_polygon(polygon):
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
	return Rect2(Vector2(min_x, min_y), Vector2(abs(max_x - min_x), abs(max_y - min_y)))

##https://www.codeproject.com/Tips/862988/Find-the-Intersection-Point-of-Two-Line-Segments

func line_segements_intersect(p, p2, q, q2):
	var intersection = Vector2()

	var r = p2 - p
	var s = q2 - q
	var rxs = r * s #cross
	var qpxr = cross(q - p, r);

	#If r x s = 0 and (q - p) x r = 0, then the two lines are collinear.
	if (is_zero(rxs) and is_zero(qpxr)):
		return false

	#If r x s = 0 and (q - p) x r != 0, then the two lines are parallel and non-intersecting.
	if (is_zero(rxs) and ! is_zero(qpxr)):
		return false

	#t = (q - p) x s / (r x s)
	var t = cross(q - p,s)/rxs

	#u = (q - p) x r / (r x s)

	var u = cross(q - p,r)/rxs

	#4. If r x s != 0 and 0 <= t <= 1 and 0 <= u <= 1
	#the two line segments meet at the point p + t r = q + u s.
	if (!is_zero(rxs) and (0 <= t && t <= 1) and (0 <= u && u <= 1)):
		#We can calculate the intersection point using either t or u.
		intersection = p + t*r;

		#An intersection was found.
		return intersection

	#5. Otherwise, the two line segments are not parallel but do not intersect.
	return null
