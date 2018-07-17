tool

extends "res://addons/entities/living_entity.gd"

onready var animation_player = get_node("AnimationPlayer")

onready var track_manager = get_node("track_manager")
onready var ladder_manager = get_node("ladder_manager")

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
	add_state("DIRECT_CONTROL")

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

func damage(d):
	.damage(d)