tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("ExtendedCollisionPolygon2D", "CollisionPolygon2D", preload("extended_collision_polygon_2D.gd"), preload("polygon.svg"))

func _exit_tree():
	remove_custom_type("HelperArea")