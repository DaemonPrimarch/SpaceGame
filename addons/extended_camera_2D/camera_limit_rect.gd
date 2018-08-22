tool
extends Polygon2D

export var simple = true setget set_simple
export var can_zoom_out = false

func _ready():
	color = Color(1,0,0, 0)
	
	if(is_simple() and not has_node("simple_limit_set_area") and Engine.editor_hint):
		var node = preload("limit_rect_setter.gd").new()
		
		node.name = "simple_limit_set_area"
		
		var pol = preload("res://addons/extended_collision_polygon_2D/extended_collision_polygon_2D.gd").new()
		
		if(polygon.size() != 0):
			pol.polygon = polygon
			
		pol.set_meta("_edit_lock_", true)
		node.add_child(pol)
		node.set_meta("_edit_lock_", true)
		add_child(node)
		
		pol.set_owner(get_tree().get_edited_scene_root())
		
		node.set_owner(get_tree().get_edited_scene_root())

func set_polygon(pol):
	.set_polygon(pol)
	
	if(is_simple() and has_node("simple_limit_set_area") and Engine.editor_hint):
		get_node("simple_limit_set_area").get_node("CollisionPolygon2D").polygon = pol

func set_simple(val):
	simple = val

func is_simple():
	return simple

func get_limit_rect():
	var box = get_node("/root/MATHS").get_AABB_of_polygon(polygon)
	
	box.position += global_position
	
	return box

func get_transition_speed():
	return 10 * 64