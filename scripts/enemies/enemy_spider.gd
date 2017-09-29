extends "res://scripts/enemies/enemy.gd"

# class member variables go here, for example:
onready var back_ground_detector = get_node("back_ground_detector")
onready var front_ground_detector = get_node("front_ground_detector")
onready var player_detector = get_node("player_detector")
var front_sighted = true


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("collision",self,"on_collision")
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

func check_for_player():
	if(player_detector.is_colliding()):
		if(player_detector.get_collider().is_in_group("player")):
			return true
	return false

func fall_down():
	set_gravity_enabled(true)
	rotate(PI)

func on_collision(info):
	var collider = info.get_collider()
	if(gravity_enabled):
		if(collider.is_in_group("terrain")):
			set_gravity_enabled(false)
		elif(collider.is_in_group("player")):
			collider.damage(8)
			collider.set_invulnerable(true)
	else:
		if(collider.is_in_group("terrain")):
			flip_up()
		elif(collider.is_in_group("player")):
			collider.damage(5)
			print("flop")
			collider.set_invulnerable(true)

func _fixed_process(delta):
	
	if(!gravity_enabled):
		if(check_for_player() and abs(get_rot() + PI)<0.1):
			fall_down()
		
		if(front_ground_detector.is_colliding()):
			front_sighted = true
		elif(!front_ground_detector.is_colliding() and !back_ground_detector.is_colliding() and front_sighted == true):
			flip_down()
			front_sighted = false
		
		move(Vector2(cos(get_rot()),-sin(get_rot()))*get_movement_speed()*delta)

