tool

extends "res://scripts/entities/living_entity.gd"

var inventory = {}

var inside_ladder = null

var velocity = Vector2()
var acceleration = Vector2()

var ladder_top = null

onready var animation_player = get_node("AnimationPlayer")

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
	
	set_state("STANDING")

func _ready():
	pass
	
func push_back():
	call_deferred("set_state", "PUSHED")

func is_inside_ladder():
	return inside_ladder != null
	
func set_ladder(ladder):
	inside_ladder = ladder
	
func set_top_ladder_area(ladder):
	ladder_top = ladder
	
func is_in_top_ladder_area():
	return ladder_top != null

func get_ladder_top():
	return ladder_top
	

func get_ladder():
	return inside_ladder

func set_velocity(v):
	velocity = v

func get_velocity():
	return velocity

func set_acceleration(v):
	acceleration = v

func get_acceleration():
	return acceleration

func add_to_inventory(key):
	inventory[key] = 1

func has_in_inventory(key):
	return (key in inventory)

func remove_from_inventory(key):
	inventory.erase(key)