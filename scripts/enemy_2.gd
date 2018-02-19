extends "res://scripts/enemy.gd"

export var charging_speed = 64*6 setget set_charging_speed, get_charging_speed
export var charging_time = 3 setget set_charging_time, get_charging_time
export var stunned_time = 2 setget set_stunned_time, get_stunned_time
onready var player_detector = get_node("player_detector")
onready var ground_detector = get_node("ground_detector")

func get_player_detector():
	return player_detector

func get_ground_detector():
	return ground_detector

func set_charging_speed(value):
	charging_speed = value

func get_charging_speed():
	return charging_speed

func set_charging_time(value):
	charging_time = value

func get_charging_time():
	return charging_time

func set_stunned_time(value):
	stunned_time = value

func get_stunned_time():
	return stunned_time

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

func _ready():
	add_state("IDLE")
	add_state("CHARGING")
	add_state("STUNNED")
	
	set_state(STATES.IDLE)

