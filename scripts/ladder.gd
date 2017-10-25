extends Area2D

func _on_ladder_body_enter( body ):
	if(body.is_in_group("player")):
		print("entered ladder")
		body.set_ladder(self)


func _on_ladder_body_exit( body ):
	if(body.is_in_group("player")):
		print("left_ladded")
		body.set_ladder(null)

func snap_to_ladder(character):
	var shape = character.get_shape(0)
	
	var aabb = math_helper.polygon_to_AABB(shape)
	
	var point
	
	if(get_scale().x < 0):
		point = aabb.end.x
	else:
		point = aabb.pos.x
	
	point += character.get_global_pos().x
	point += character.get_shape_transform(0).get_origin().x
	
	var dir = get_global_pos().x - point - (get_item_rect().size.x/2) * get_scale().x/abs(get_scale().x)
	print(character.get_global_pos().x + dir)
	character.move(Vector2(dir, 0))
	
