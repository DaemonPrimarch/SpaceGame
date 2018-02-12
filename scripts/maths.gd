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

##https://www.codeproject.com/Tips/862988/Find-the-Intersection-Point-of-Two-Line-Segments
#
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
