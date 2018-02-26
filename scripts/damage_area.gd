tool

extends Node2D

signal activated
signal deactivated

export var active = true setget set_active, is_active

export var damage = 10 setget set_damage, get_damage

onready var area = get_node("Area2D")

func set_active(val):
	if(is_active() != val):
		active = val
		
		if(val):
			area.set_collision_layer_bit(0,1)
			visible = true
			emit_signal("activated")
		else:
			area.set_collision_layer_bit(0,0)
			visible = false
			emit_signal("deactivated")

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
		if(body is preload("res://scripts/entity.gd")):
			body.damage(get_damage())
		if(body is preload("res://scripts/playable_character.gd")):
			#body.push_back()
			pass
