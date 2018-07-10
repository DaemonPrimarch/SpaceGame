tool

extends StaticBody2D

export var active = true setget set_active, is_active

func set_active(val):
	active = val
	
	if(is_inside_tree()):
		$CollisionPolygon2D.disabled = not val
		visible = val
	
func is_active():
	return active

func _ready():
	set_active(is_active())

func switch():
	set_active(not is_active())