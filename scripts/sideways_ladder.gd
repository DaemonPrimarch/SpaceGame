extends "res://scripts/ladder.gd"

func get_type():
	if(get_scale().x > 0):
		return TYPES.RIGHT
	else:
		return TYPES.LEFT

func snap_to_ladder(character):
	var shape = character.get_shape(0)
	
	var aabb = math_helper.polygon_to_AABB(shape)
	
	var point
	
	if(get_type() == TYPES.RIGHT):
		point = aabb.end.x
	else:
		point = aabb.pos.x
	
	point += character.get_global_pos().x
	point += character.get_shape_transform(0).get_origin().x
	
	var dir = get_global_pos().x - point - (get_item_rect().size.x/2) * get_scale().x/abs(get_scale().x)
	character.move(Vector2(dir, 0))
	
	.snap_to_ladder(character)