extends "res://scripts/enemy.gd"

export var charging_speed = 64*6 setget set_charging_speed, get_charging_speed
onready var player_detector = get_node("player_detector")
onready var ground_detector = get_node("ground_detector")

func get_player_detector():
	return player_detector

func set_charging_speed(value):
	charging_speed = value

func get_charging_speed():
	return charging_speed

func _ready():
	add_state("IDLE")
	add_state("CHARGING")
	add_state("STUNNED")
	
	set_state(STATES.IDLE)

