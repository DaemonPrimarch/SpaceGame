tool

extends "res://scripts/entities/enemies/enemy.gd"

onready var ground_detector = get_node("ground_detector")
onready var wall_detector = get_node("wall_detector")

func _physics_process(delta):
	move_and_collide_slope(get_direction() * Vector2(1,0) * -1 * delta * get_movement_speed())
	
	if(not ground_detector.is_colliding() or wall_detector.is_colliding()):
		set_flippedH(not is_flippedH())
		

func crush():
	destroy()