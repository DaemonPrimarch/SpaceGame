tool

extends Node2D

signal on_ready

signal length_changed

export(int, 64, 3200, 64) var length = 64 setget set_length, get_length

var original_sprite_pos = Vector2()

var loaded = false

signal children_loaded

export var flippedH = false setget set_flippedH, is_flippedH
export var flippedV = false setget set_flippedV, is_flippedV

func is_flippedH():
	return flippedH

func is_flippedV():
	return flippedV

func set_flippedH(val):
	if(is_inside_tree()):
		var dir = 1
		
		if(val):
			dir = -1
		
		for child in get_children():
			if(child is Node2D):
				child.set_scale(child.get_scale().abs() * Vector2(dir,1))
				child.set_position(child.get_position().abs() * Vector2(dir,1))
				child.set_rotation(-child.get_rotation())
			if(child is Control):
				child.rect_position = child.rect_position.abs()  * Vector2(dir,1)
		
	flippedH = val

func set_flippedV(val):
	if(val != is_flippedV()):
		for child in get_children():
			if(child is Node2D):
				child.set_scale(child.get_scale() * Vector2(1,-1))
				child.set_position(child.get_position() * Vector2(1,-1))
	
	flippedV = val

func _ready():
	loaded = true
	
	set_flippedH(is_flippedH())
	
	emit_signal("on_ready")
	
func set_length(l):
	length = l


	emit_signal("length_changed")

func snap_to(node):
	pass

func get_length():
	return length

func _on_Area2D_body_entered( body ):
	if(body.is_in_group("handles_ladder")):
		body.get_node("ladder_manager").set_ladder(self)

func _on_Area2D_body_exited( body ):
	if(body.is_in_group("handles_ladder")):
		body.get_node("ladder_manager").set_ladder(null)

func _on_ladder_length_changed():
	var polygon = get_node("Area2D/CollisionPolygon2D").get_polygon()

	for i in range(0, polygon.size()):
		if(polygon[i].y >= 0):
			polygon[i] = Vector2(polygon[i].x, get_length() - 32)

	get_node("Area2D/CollisionPolygon2D").set_polygon(polygon)

	get_node("Sprite").set_region_rect(Rect2(0,0,64, get_length()))

	get_node("Sprite").set_position(Vector2(get_node("Sprite").get_position().x, get_length()/2 - 32))

	get_node("Control/Panel").rect_scale = Vector2(get_node("Control/Panel").rect_scale.x, get_length()/2)

