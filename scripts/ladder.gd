tool

extends Node2D

signal on_ready

signal length_changed

export(int, 64, 3200, 64) var length = 64 setget set_length, get_length

var original_sprite_pos = Vector2()

var loaded = false

signal children_loaded

func _ready():
	loaded = true
	
	emit_signal("on_ready")
	
func set_length(l):
	length = l

	emit_signal("length_changed")

func snap_to(node):
	pass

func get_length():
	return length

func _on_Area2D_body_entered( body ):
	if(body.is_in_group("can_climb_ladder")):
		body.set_ladder(self)

func _on_Area2D_body_exited( body ):
	if(body.is_in_group("can_climb_ladder")):
		body.set_ladder(null)

func _on_ladder_length_changed():
	var polygon = get_node("Area2D/CollisionPolygon2D").get_polygon()

	for i in range(0, polygon.size()):
		if(polygon[i].y >= 0):
			polygon[i] = Vector2(polygon[i].x, get_length() - 32)
	get_node("Area2D/CollisionPolygon2D").set_polygon(polygon)
	
	get_node("Sprite").set_region_rect(Rect2(0,0,64, get_length()))
	
	get_node("Sprite").set_position(Vector2(get_node("Sprite").get_position().x, get_length()/2 - 32))
	
	get_node("Control/Panel").rect_scale = Vector2(get_node("Control/Panel").rect_scale.x, get_length()/2)
