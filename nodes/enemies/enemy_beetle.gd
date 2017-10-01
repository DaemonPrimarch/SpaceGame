extends "res://scripts/enemies/enemy.gd"

# class member variables go here, for example:
onready var player_detector = get_node("player_detector")
var player_detected = false
var move_up = false
var rot = 0
var dir = 1
var starting_height
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("collision",self,"on_collision")
	set_fixed_process(true)
	starting_height = get_pos()[1]
	print(starting_height)

func on_collision(info):
	if(info.get_collider().is_in_group("terrain")):
		if(player_detected):
			move_up = true
		elif(move_up):
			move_up = false
			player_detected = false
		else:
			dir = -dir
			if(flippedH):
				set_flippedH(false)
			else:
				set_flippedH(true)
	elif(info.get_collider().is_in_group("player")):
		info.get_collider().damage(5)
		info.get_collider().set_invulnerable(true)
		if(player_detected):
			move_up = true

func _fixed_process(delta):
	if(move_up):
		#print("move_up")
		move(Vector2(0,-1)*get_movement_speed()*delta)
		if(get_pos()[1] < starting_height):
			print(get_pos()[1])
			move_up = false
			player_detected = false
	else:
		if(player_detector.is_colliding()):
			if(player_detector.get_collider().is_in_group("player")):
				#print("gotcha!")
				player_detected = true
		if(player_detected):
			#print("attack")
			move(Vector2(1*dir,1)*get_movement_speed()*delta)
		else:
			rot += PI/20
			if(rot>=2*PI):
				rot = 0
			move(Vector2(1*dir,sin(rot))*get_movement_speed()*delta)
