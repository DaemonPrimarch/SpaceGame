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
				body.get_node("respawn_manager").respawn()