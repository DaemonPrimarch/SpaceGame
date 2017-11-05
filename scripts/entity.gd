tool
extends "res://scripts/better_KinematicBody2D.gd"

signal hp_changed

export var movement_speed = 300 setget set_movement_speed,get_movement_speed

export var flippedH = false setget set_flippedH, is_flippedH
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

var gravity_timer = 0
var gravity_timer_started = false

var loaded = false

onready var gravity_vector = Physics2DServer.area_get_param(get_world_2d().get_space(),Physics2DServer.AREA_PARAM_GRAVITY_VECTOR) * Physics2DServer.area_get_param(get_world_2d().get_space(),Physics2DServer.AREA_PARAM_GRAVITY)*7

func children_loaded():
	return loaded

func _ready():
	loaded = true
	
	#set_flippedH(is_flippedH())
	
	if(not get_tree().is_editor_hint()):
		add_to_group("has_hp_bar")
		get_node("/root/GUI").add_HP_bar(self)
		
		if(has_invulnerability_timer()):
			var timer = Timer.new()
			timer.set_wait_time(get_invulnerability_time())
			timer.set_name("invulnerability_timer")
			timer.set_one_shot(true)
			timer.connect("timeout", self, "on_invulnerability_timer_timeout")
			add_child(timer)
			invulnerability_timer = timer
		

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
	set_collision_mask_bit(1, not value)
	if(value):
		invulnerability_timer.start()
		if(has_invulnarable_animation):
			get_node(invulnerable_animation_player).play("invulnerable")
	else:
		if(invulnerability_timer.get_time_left() > 0):
			invulnerability_timer.stop()
		if(has_invulnarable_animation):
			get_node(invulnerable_animation_player).stop()

func finland_suckt():
	print("Finlad suckts")
	set_invulnerable(false)
func on_invulnerability_timer_timeout():
	set_invulnerable(false)

func set_HP(val):
	hp = val
	emit_signal("hp_changed")
	
func get_HP():
	return hp

func get_max_HP():
	return max_HP

func on_bullet_hit(bullet):
	print("?")
	damage(bullet.get_damage())

func damage(amount):
	var new_HP = get_HP() - amount
	
	if(new_HP <= 0):
		self.destroy()
	else:
		set_HP(new_HP)

func set_gravity_enabled(value):
	gravity_enabled = value

func is_gravity_enabled():
	return gravity_enabled

func set_gravity_vector(vector):
	gravity_vector = vector

func get_gravity_vector():
	return gravity_vector

func is_on_ground():
	return on_ground

func is_flippedH():
	if(children_loaded()):
		return flippedH
	else:
		return flippedH

#Flips all children horizontally, ignores all children in group ignores_flip.
func set_flippedH(new):
	if(is_flippedH() != new):
		flippedH = new
		
		for N in get_children():
			if(N extends Node2D and !N.is_in_group("ignores_flip")):
				N.set_scale(N.get_scale() * Vector2(-1, 1))
				N.set_pos(N.get_pos() * Vector2(-1, 1))
				N.set_rot(- N.get_rot())

func apply_gravity(delta):
	if(move(get_gravity_vector() * delta * gravity_timer).has_collision()):
		on_ground = true
	
func reset_gravity_timer():
	gravity_timer = 0

func _fixed_process(delta):
	if(is_on_ground()):
		if(not test_move(get_gravity_vector().normalized() * 1)):
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