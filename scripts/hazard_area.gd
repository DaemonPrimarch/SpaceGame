extends Area2D

signal apply_continuous_effect
signal activated
signal deactivated

export var active = true setget set_active, is_active
export var damage = 1 setget set_damage,get_damage
export var pushes = false
export var push_time = 5 setget set_push_time, get_push_time
export var push_time_extended = 5 setget set_push_time_extended, get_push_time_extended
export var push_velocity = Vector2(4*64,2*64) setget set_push_velocity, get_push_velocity

func on_body_enter(body):
	if(is_active()):
		if(body.is_in_group("player") and body.get_current_state() != body.STATE.PUSHED):
			body.set_invulnerable(true)
			body.push(get_push_time(), get_push_time_extended(),get_push_velocity())

func deal_damage_to_players():
	for body in get_overlapping_bodies():
		if(body.is_in_group("player")):
			body.damage(get_damage())

func _fixed_process(delta):
	if(is_active()):
		emit_signal("apply_continuous_effect")

func set_active(value):
	set_hidden(not value)
	
	active = value
	
	if(value):
		emit_signal("activated")
	else:
		emit_signal("deactivated")
	
	if(is_inside_tree() and is_monitoring_enabled()):
		for body in get_overlapping_bodies():
			emit_signal("body_enter", body)
	
func is_active():
	return active

func pushes():
	return pushes

func set_push_velocity(value):
	push_velocity = value

func get_push_velocity():
	return push_velocity

func set_push_time(value):
	push_time = value

func get_push_time():
	return push_time

func set_push_time_extended(value):
	push_time_extended = value

func get_push_time_extended():
	return push_time_extended

func set_damage(value):
	damage = value

func get_damage():
	return damage
	
func _ready():
	set_fixed_process(true)
	if(pushes()):
		connect("body_enter", self, "on_body_enter")
	else:
		connect("apply_continuous_effect", self, "deal_damage_to_players")