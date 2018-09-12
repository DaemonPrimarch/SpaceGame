extends "res://scripts/weapons/bullet.gd"

var player_to_follow

func _ready():
	for player in get_tree().get_nodes_in_group("player"):
		player_to_follow = player

func process_move(delta):
	var dir = 0
	var a = rotation
	var b = rotation + PI
	if(b >= PI):
		b = -PI + (b -PI)
	if( player_to_follow.position.angle_to_point(position) > b and b >= 0):
		dir = -1
	elif( player_to_follow.position.angle_to_point(position) < a and a <= 0):
		dir = -1
	elif(b >= 0 and a <= 0):
		dir = 1
	elif(player_to_follow.position.angle_to_point(position) < b and b <= 0):
		dir = 1
	elif(player_to_follow.position.angle_to_point(position) > a and a >= 0):
		dir = 1
	else:
		dir = -1

	rotation += dir*delta*4

	if(rotation >= PI):
		rotation = -PI + (rotation -PI)
	if(rotation <= -PI):
		rotation = PI - (rotation +PI)

	position += get_velocity().rotated(get_rotation()) * delta
