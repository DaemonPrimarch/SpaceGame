extends "res://scripts/enemies/enemy.gd"

# class member variables go here, for example:
onready var back_ground_detector = get_node("back_ground_detector")
onready var front_ground_detector = get_node("front_ground_detector")
var front_sighted = true


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)

func flip_up():
	rotate(PI/2)

func flip_down():
	rotate(-PI/2)

func get_distance_to_nearest_player():
	var players = get_tree().get_nodes_in_group("player")
	var closest_distance = x_distance(self,players[0])
	for player in players:
		var current_distance = x_distance(self,player)
		if (current_distance < closest_distance):
			closest_distance = current_distance
	return closest_distance

#Returns the difference in x-coördinates between two objects.
func x_distance(body1, body2):
	return abs(body1.get_pos()[0] - body2.get_pos()[0])

func _fixed_process(delta):
	if(front_ground_detector.is_colliding()):
		front_sighted = true
	elif(!front_ground_detector.is_colliding() and !back_ground_detector.is_colliding() and front_sighted == true):
		flip_down()
		front_sighted = false
	if(move(Vector2(cos(get_rot()),-sin(get_rot()))*get_movement_speed()*delta).has_collision()):
		flip_up()
