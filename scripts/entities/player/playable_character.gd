tool

extends "res://scripts/entities/living_entity.gd"

var inventory = {}

var inside_ladder = null

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
	var max_y = pol[0].y
	var min_y = pol[0].y
	var max_x = pol[0].x
	var min_x = pol[0].x
	
	for element in pol:
		if(element.y < max_y):
			max_y = element.y
		elif(element.y > min_y):
			min_y = element.y
		if(element.x > max_x):
			max_x = element.x
		if(element.x < min_x):
			min_x = element.x
	
	return Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))