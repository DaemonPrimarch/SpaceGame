 extends "res://scripts/better_KinematicBody2D.gd"

signal hp_changed
signal hit_by_bullet

export var movement_speed = 300 setget set_movement_speed,get_movement_speed

var warping = false
var gravity_vector
var gravity_damp = 1 setget set_gravity_damp, get_gravity_damp

export var flippedH = false
export var gravity_enabled = true

export var max_HP = 10
export var hp = 10 setget set_HP, get_HP

var destroyed = false
var on_ground = false

var invulnerable = false
export var invulnerability_time = 5
export var uses_invulnerability_timer = true
export var has_invulnarable_animation = false
export var invulnerable_animation_player = "SecondAnimationPlayer"

var invulnerability_timer
var invulnerability_timer_running = false

var gravity_timer = 0
var gravity_timer_started = false

func _ready():
	add_to_group("has_hp_bar")
	GUI.add_HP_bar(self)

func set_gravity_damp(value):
	gravity_damp = value

func get_gravity_damp():
	return gravity_damp

func get_invulnerability_time():
	return invulnerability_time

func set_movement_speed(value):
	movement_speed = value

func get_movement_speed():
	return movement_speed

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
		if(has_invulnarable_animation):
			get_node(invulnerable_animation_player).play("invulnerable")
	else:
		if(invulnerability_timer_running):
			invulnerability_timer.stop()
			invulnerability_timer.free()
			invulnerability_timer_running = false
		if(has_invulnarable_animation):
			get_node(invulnerable_animation_player).stop()
func on_invulnerability_timer_timeout():
	print("timeout")
	invulnerability_timer_running = false
	set_invulnerable(false)

func set_HP(val):
	hp = val
	emit_signal("hp_changed")
	
func get_HP():
	return hp

func get_max_HP():
	return max_HP

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

func get_gravity_vector():
	return Physics2DServer.area_get_param(get_world_2d().get_space(),Physics2DServer.AREA_PARAM_GRAVITY_VECTOR) * Physics2DServer.area_get_param(get_world_2d().get_space(),Physics2DServer.AREA_PARAM_GRAVITY)*7

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
	#Normally this should be /2 not /20 for some reason the godot gravity vector is 98, not 9.8
	#print(get_gravity_vector() * gravity_timer)
	if(move(get_gravity_vector() * delta * gravity_timer).has_collision()):
		on_ground = true
	
func _fixed_process(delta):
	if(is_on_ground()):
		if(not test_move(get_gravity_vector().normalized() * 0.08)):
			on_ground = false
	if(is_gravity_enabled() and not is_on_ground()):
		if(not gravity_timer_started):
			gravity_timer_started = true
		gravity_timer += delta
				
		apply_gravity(delta)
	elif(gravity_timer_started):
		gravity_timer_started = false
		gravity_timer = 0

func is_destroyed():
	return destroyed

func destroy():
	destroyed = true
	queue_free()