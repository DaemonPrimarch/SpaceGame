tool

extends Node2D

signal activated
signal deactivated

export var active = true setget set_active, is_active
export var damage = 10 setget set_damage, get_damage
export var respawn_entity = false

func _ready():
	$Area2D.connect("body_entered", self, "_on_Area2D_body_entered")

func set_active(val):
		active = val
		
		if(val):
			visible = true
			call_deferred("emit_signal", "activated")
		else:
			visible = false
			call_deferred("emit_signal", "deactivated")

func is_active():
	return active

func toggle_active():
	set_active(not is_active())

func set_damage(val):
	damage = val

func get_damage():
	return damage

func _on_Area2D_body_entered( body ):
	if(is_active()):
		if(body.is_in_group("living_entity")):
			body.damage(get_damage())
			if(respawn_entity and body.has_node("respawn_manager")):
				body.get_node("respawn_manager").call_deferred("respawn")

func _on_Area2D_AABB_changed():
	$TemporarySprite.rect_position = to_local($Area2D.get_AABB().position)
	$TemporarySprite.rect_size = $Area2D.get_AABB().size
	
	$TemporarySprite/Sprite.scale = $Area2D.get_AABB().size / Vector2(64, 64 * 4)
	
	print("EDITED")