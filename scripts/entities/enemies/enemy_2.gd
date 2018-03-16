extends "res://scripts/entities/enemies/enemy.gd"

export var charging_acceleration = 64*30 setget set_charging_acceleration, get_charging_acceleration
export var starting_speed = 64*4 setget set_starting_speed, get_starting_speed
export var max_speed = 64*18 setget set_max_speed,get_max_speed
export var stunned_time_crashed = 2 setget set_stunned_time_crashed, get_stunned_time_crashed
export var stunned_time_exhausted = 1 setget set_stunned_time_exhausted, get_stunned_time_exhausted
export var overrun_distance = 4*64 setget set_overrun_distance, get_overrun_distance
onready var player_detector = get_node("player_detector")
onready var ground_detector = get_node("ground_detector")

var charging_distance

func get_player_detector():
	return player_detector

func get_ground_detector():
	return ground_detector

func set_charging_acceleration(value):
	charging_acceleration = value

func get_charging_acceleration():
	return charging_acceleration
	
func set_starting_speed(val):
	starting_speed = val

func get_starting_speed():
	return starting_speed

func set_max_speed(val):
	max_speed = val

func get_max_speed():
	return max_speed

func set_charging_distance(value):
	charging_distance = value

func get_charging_distance():
	return charging_distance

func set_stunned_time_crashed(value):
	stunned_time_crashed = value

func get_stunned_time_crashed():
	return stunned_time_crashed

func set_stunned_time_exhausted(value):
	stunned_time_exhausted = value

func get_stunned_time_exhausted():
	return stunned_time_exhausted

func set_overrun_distance(val):
	overrun_distance = val

func get_overrun_distance():
	return overrun_distance

func _on_bullet_hit(bullet):
	if(get_direction().x > 0):
		if(get_position().x - bullet.get_position().x > 0):
			#hit
			damage(bullet.get_damage())
		else:
			#miss
			pass
	else:
		if(get_position().x - bullet.get_position().x < 0):
			#hit
			damage(bullet.get_damage())
		else:
			#miss
			pass

func _init():
	add_state("IDLE")
	add_state("CHARGING")
	add_state("STUNNED_BY_CRASH")
	add_state("STUNNED_BY_EXHAUSTION")
	
	set_state("IDLE")

