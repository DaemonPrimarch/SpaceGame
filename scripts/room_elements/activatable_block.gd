tool

extends StaticBody2D

export var active = true setget set_active, is_active

func set_active(val):
	active = val
	
	if(is_inside_tree()):
		$ExtendedCollisionPolygon2D.disabled = not val
		visible = val
	
func is_active():
	return active

func _ready():
	set_active(is_active())
	
	$ExtendedCollisionPolygon2D.connect("AABB_changed", self, "_on_aabb_changed")

func switch():
	set_active(not is_active())

func _on_aabb_changed():
	$TemporarySprite.rect_position = to_local($ExtendedCollisionPolygon2D.get_AABB().position)
	$TemporarySprite.rect_size = $ExtendedCollisionPolygon2D.get_AABB().size
	$TemporarySprite/Sprite.scale = $ExtendedCollisionPolygon2D.get_AABB().size / Vector2(64, 64)
	