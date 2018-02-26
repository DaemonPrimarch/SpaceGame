tool

extends "res://scripts/entity.gd"

export(NodePath) var weapon_path setget set_weapon_path

export var jump_enabled = true
export var double_jump_enabled = true
export var wall_jump_enabled = true

export var jump_height = 64 * 4
export var double_jump_height = 64 * 2
export var wall_jump_distance = Vector2(64,64)

export var stunned_time = 1

export var climbing_speed = 64 * 2 

var inventory = {}

var jumping_timer = 0
var double_jumping_timer = 0
var wall_jumping_timer = 0
var stunned_timer = 0

var inside_ladder = null

var double_jumped = false

var on_platform = false

var wall_slide_side = 1 #1 is Right, -1 is Left

var velocity = Vector2()
var acceleration = Vector2()

var in_no_respawn_area = false
var in_no_wall_slide = false

var last_safe_position = Vector2()

onready var weapon_top_position = get_node("weapon_top")
onready var weapon_top_front_position = get_node("weapon_top_front")
onready var weapon_front_position = get_node("weapon_front")
onready var weapon_bottom_front_position = get_node("weapon_bottom_front")
onready var weapon_bottom_position = get_node("weapon_bottom")
onready var animation_player = get_node("AnimationPlayer")

onready var wall_slide_detector_up = get_node("wall_slide_detector_up")
onready var wall_slide_detector_down = get_node("wall_slide_detector_down")

func _ready():
	add_state("REGULAR_JUMPING")
	add_state("DOUBLE_JUMPING")
	add_state("WALL_JUMPING")
	add_state("WALL_SLIDING")
	add_state("FALLING")
	add_state("CLIMBING")
	add_state("CROUCHING")
	add_state("PUSHED")
	add_state("STANDING")
	add_state("WALKING")
	
	set_state(STATES.STANDING)

func _physics_process(delta):
	get_node("ground_detector").force_raycast_update()
	
	if(not is_in_no_respawn_area() and is_grounded() and get_node("ground_detector").is_colliding() and get_node("ground_detector").get_collider().is_in_group("terrain")):
		set_last_safe_position(get_position())
		
func push_back():
	yield(get_tree(), "idle_frame")
	
	set_state(STATES.PUSHED)

func get_stunned_time():
	return stunned_time

func is_inside_ladder():
	return inside_ladder != null
	
func set_ladder(ladder):
	inside_ladder = ladder

func get_ladder():
	return inside_ladder

func set_climbing_speed(speed):
	climbing_speed = speed

func get_climbing_speed():
	return climbing_speed

func get_jump_height():
	return jump_height

func get_double_jump_height():
	return double_jump_height

func calculate_starting_velocity_y(height, acceleration_y):
	return -calculate_max_airtime(height, acceleration_y) * acceleration_y

func calculate_max_airtime(height, acceleration_y):
	var D = 1 + 2 * acceleration_y * height
	
	return (-1 + sqrt(D))/acceleration_y


func set_velocity(v):
	velocity = v

func get_velocity():
	return velocity

func set_acceleration(v):
	acceleration = v

func get_acceleration():
	return acceleration

func is_on_platform():
	return on_platform

func set_on_platform(val):
	on_platform = val

func is_grounded():
	return (.is_grounded() or is_on_platform())

func can_jump():
	return jump_enabled

func can_double_jump():
	return double_jump_enabled and not double_jumped
	
func can_wall_jump():
	return wall_jump_enabled

func can_wall_slide_on_node(node):
	if(node is TileMap):
		return true
	else:
		return node.is_in_group("wall_slideable")

func can_wall_slide():	
	return wall_jump_enabled and wall_slide_detector_up.is_colliding() and wall_slide_detector_down.is_colliding() and can_wall_slide_on_node(wall_slide_detector_down.get_collider()) and can_wall_slide_on_node(wall_slide_detector_up.get_collider()) and not is_in_no_wall_slide_area()

func set_wall_slide_side(side):
	wall_slide_side = side
	
func get_wall_slide_side():
	return wall_slide_side

func get_weapon():
	return get_node(weapon_path)
	
func set_weapon_path(path):
	weapon_path = path

func has_weapon():
	return weapon_path != null
	
func respawn():
	set_position(get_last_safe_position())
	
func crush():
	.crush()
	
	respawn()

func is_in_no_wall_slide_area():
	return in_no_wall_slide

func set_in_no_wall_slide_area(val):
	in_no_wall_slide = val

func is_in_no_respawn_area():
	return in_no_respawn_area

func set_in_no_respawn_area(val):
	in_no_respawn_area = val

func get_last_safe_position():
	return last_safe_position
	
func set_last_safe_position(v):
	last_safe_position = v

func add_to_inventory(key):
	inventory[key] = 1

func has_in_inventory(key):
	return (key in inventory)

func remove_from_inventory(key):
	inventory.erase(key)

func _on_room_entered():
	if(get_node("/root/ROOM_MANAGER").get_room_of_node(self).is_dark()):
		get_node("light").enabled = true
	else:
		get_node("light").enabled = false
