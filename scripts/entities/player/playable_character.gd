tool

extends "res://scripts/entities/living_entity.gd"

var inventory = {}

var inside_ladder = null
var previous_ladder = null

var velocity = Vector2()
var acceleration = Vector2()

var ladder_top = null

onready var animation_player = get_node("AnimationPlayer")
onready var col_pol = get_node("CollisionPolygon2D")

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

func is_inside_walled_ladder():
	return is_inside_ladder() and get_ladder().is_in_group("walled_ladder")
	
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

func get_AABB():
	var pol = col_pol.get_polygon()
	var new_pos = to_local(col_pol.to_global(pol[0]))
	var max_y = new_pos.y
	var min_y = new_pos.y
	var max_x = new_pos.x
	var min_x = new_pos.x
	
	for element_local in pol:
		var element = to_local(col_pol.to_global(element_local))
		if(element.y < max_y):
			max_y = element.y
		elif(element.y > min_y):
			min_y = element.y
		if(element.x > max_x):
			max_x = element.x
		if(element.x < min_x):
			min_x = element.x
	
	if(is_flippedH()):
		var nbx = min_x
		min_x = -max_x
		max_x = -nbx
	
	#if(is_flippedV()):
	#	var nby = min_y
	#	min_y = -max_y
	#	max_y = -nby
	
	return Rect2(Vector2(min_x, min_y), Vector2(abs(max_x - min_x), abs(max_y - min_y)))