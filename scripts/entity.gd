extends "res://scripts/better_KinematicBody2D.gd"

var warping = false

export var flippedH = false
export var gravity_enabled = true
export var gravity_vector = Vector2(0, 98 * 2)

var on_ground = false

func is_warping():
	return warping
	
func set_is_warping(val):
	warping = val

func set_gravity_enabled(value):
	gravity_enabled = value

func is_gravity_enabled():
	return gravity_enabled

func is_on_ground():
	return on_ground

func is_flippedH():
	return flippedH

func set_flippedH(new):
	if(is_flippedH() != new):
		flippedH = new
		
		for N in get_children():
			if(N extends Node2D):
				N.set_scale(N.get_scale() * Vector2(-1, 1))
				N.set_pos(N.get_pos() * Vector2(-1, 1))

func apply_gravity(delta):
	if(move(gravity_vector * delta)):
		print("Now on ground")
		on_ground = true
	
func _fixed_process(delta):
	if(is_on_ground()):
		if(not test_move(gravity_vector.normalized() * 0.08)):
			on_ground = false
			print("Now off ground")
	if(is_gravity_enabled() and not is_on_ground()):
		apply_gravity(delta)
		print("Applying")
