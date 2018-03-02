tool

extends Node2D

signal activated
signal deactivated

export var active = true setget set_active, is_active

export var damage = 10 setget set_damage, get_damage

onready var area = get_node("Area2D")

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
		if(body.has_method("damage")):
			body.damage_push(self)
			body.damage(get_damage())
		if(not true):
			#body.push_back()
			pass
