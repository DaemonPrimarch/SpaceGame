extends "res://scripts/enemies/enemy.gd"

# class member variables go here, for example:
onready var player_detector = get_node("player_detector")
onready var left_point = get_parent().get_node("left_turn")
onready var right_point = get_parent().get_node("right_turn")
var player_detected = false
export var going_right = true
var move_up = false
var rot = 0
var dir
var starting_height
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	if(going_right):
		dir = 1
	else:
		dir = -1
	connect("collision",self,"on_collision")
	set_fixed_process(true)
	starting_height = get_pos()[1]

func on_collision(info):
	if(info.get_collider().is_in_group("terrain")):
		if(player_detected):
			move_up = true
		elif(move_up):
			move_up = false
			player_detected = false
		else:
			turn()
	elif(info.get_collider().is_in_group("player")):
		info.get_collider().damage(5)
		info.get_collider().set_invulnerable(true)
		if(player_detected):
			move_up = true

func _fixed_process(delta):
	if(move_up):
		move(Vector2(0,-1)*get_movement_speed()*delta)
		if(get_pos().y < starting_height):
			print(get_pos().y)
			move_up = false
			player_detected = false
	else:
		if(player_detector.is_colliding()):
			if(player_detector.get_collider().is_in_group("player")):
				player_detected = true
		if(player_detected):
			move(Vector2(1*dir,1)*get_movement_speed()*delta)
		else:
			rot += PI/20
			if(rot>=2*PI):
				rot = 0
			move(Vector2(1*dir,sin(rot))*get_movement_speed()*delta)
			if((get_pos().x >= right_point.get_pos().x and going_right) or (get_pos().x <= left_point.get_pos().x and not going_right)):
				turn()

func turn():
	going_right = !going_right
	dir = -dir
	if(flippedH):
		set_flippedH(false)
	else:
		set_flippedH(true)

func destroy():
	get_parent().queue_free()
	.destroy()