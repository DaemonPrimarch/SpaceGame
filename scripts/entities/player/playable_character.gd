tool

extends "res://addons/entities/living_entity.gd"

onready var animation_player = get_node("AnimationPlayer")

onready var track_manager = get_node("track_manager")
onready var ladder_manager = get_node("ladder_manager")

onready var col_pol = get_node("CollisionPolygon2D")

func _init():
	add_state("REGULAR_JUMPING")
	add_state("DOUBLE_JUMPING")
	add_state("WALL_JUMPING")
	add_state("WALL_SLIDING")
	add_state("FALLING")
	add_state("CLIMBING")
	add_state("CROUCHING")
	add_state("CRAWLING")
	add_state("PUSHED")
	add_state("STANDING")
	add_state("WALKING")
	add_state("ON_TRACK")
	add_state("TRACK_JUMPING")

export var action_override = false

var actions_pressed = {}

func is_action_override():
	return action_override

func set_action_pressed(action, val):
	if(is_action_override()):
		actions_pressed[actions_pressed] = val
	else:
		print("ACTIONS NOT OVERRIDEN")

func is_action_pressed(action):
	if(is_action_override()):
		if(not actions_pressed[action] is null):
			return actions_pressed[action]
		else:
			return false
	else:
		return Input.is_action_pressed(action)

func is_action_just_pressed(action):
	return Input.is_action_just_pressed(action)

func push_back():
	call_deferred("set_state", "PUSHED")

#LADDER HANDLERS:

#func get_AABB():
#	var pol = col_pol.get_polygon()
#	var new_pos = to_local(col_pol.to_global(pol[0]))
#	var max_y = new_pos.y
#	var min_y = new_pos.y
#	var max_x = new_pos.x
#	var min_x = new_pos.x
#
#	for element_local in pol:
#		var element = to_local(col_pol.to_global(element_local))
#		if(element.y < max_y):
#			max_y = element.y
#		elif(element.y > min_y):
#			min_y = element.y
#		if(element.x > max_x):
#			max_x = element.x
#		if(element.x < min_x):
#			min_x = element.x
#
#	if(is_flippedH()):
#		var nbx = min_x
#		min_x = -max_x
#		max_x = -nbx
#
#	#if(is_flippedV()):
#	#	var nby = min_y
#	#	min_y = -max_y
#	#	max_y = -nby
#
#	return Rect2(Vector2(min_x, min_y), Vector2(abs(max_x - min_x), abs(max_y - min_y)))

func damage(d):
	.damage(d)