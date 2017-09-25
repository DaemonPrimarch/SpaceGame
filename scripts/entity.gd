extends "res://scripts/better_KinematicBody2D.gd"

signal hp_changed
signal hit_by_bullet

var warping = false

export var flippedH = false
export var gravity_enabled = true
export var gravity_vector = Vector2(0, 98 * 2)

export var max_HP = 10
export var hp = 10 setget set_HP, get_HP

var destroyed = false
var on_ground = false

var invulnerable = false
export var invulnerability_time = 5
export var uses_invulnerability_timer = true
var invulnerability_timer
var invulnerability_timer_running = false

func get_invulnerability_time():
	return invulnerability_time

func is_invulnerable():
	return invulnerable

func has_invulnerability_timer():
	return uses_invulnerability_timer

func set_invulnerable(value):
	invulnerable = value
	set_collision_mask_bit(1, !value)
	if(value):
		invulnerability_timer = Timer.new()
		invulnerability_timer.set_one_shot(true)
		invulnerability_timer.set_wait_time(get_invulnerability_time())
		self.add_child(invulnerability_timer)
		invulnerability_timer.connect("timeout", self, "on_invulnerability_timer_timeout")
		invulnerability_timer_running = true
		invulnerability_timer.start()
	else:
		if(invulnerability_timer_running):
			invulnerability_timer.stop()
			invulnerability_timer.free()
			invulnerability_timer_running = false

func on_invulnerability_timer_timeout():
	print("timeout")
	invulnerability_timer_running = false
	set_invulnerable(false)

func set_HP(val):
	hp = val
	emit_signal("hp_changed")
	
func get_HP():
	return hp

func damage(amount):
	var new_HP = get_HP() - amount
	
	if(new_HP <= 0):
		self.destroy()
	else:
		set_HP(new_HP)

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

#Flips all children horizontally, ignores all children in group ignores_flip.
func set_flippedH(new):
	if(is_flippedH() != new):
		flippedH = new
		
		for N in get_children():
			if(N extends Node2D and !N.is_in_group("ignores_flip")):
				N.set_scale(N.get_scale() * Vector2(-1, 1))
				N.set_pos(N.get_pos() * Vector2(-1, 1))

func apply_gravity(delta):
	if(move(gravity_vector * delta)):
		on_ground = true
	
func _fixed_process(delta):
	if(is_on_ground()):
		if(not test_move(gravity_vector.normalized() * 0.08)):
			on_ground = false
	if(is_gravity_enabled() and not is_on_ground()):
		apply_gravity(delta)

func is_destroyed():
	return destroyed

func destroy():
	destroyed = true
	queue_free()