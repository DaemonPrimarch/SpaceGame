tool
extends StaticBody2D

export var moving_forward = true setget set_moving_forward
export var speed = 64 setget set_speed
export(int, 64, 640000, 64)  var length = 64 setget set_length

func _ready():
	set_length(length)

func set_speed(p_speed):
	speed = p_speed

func set_moving_forward(val):
	moving_forward = val

func is_moving_forward():
	return moving_forward

func set_length(p_length):
	length = p_length
	
	if(is_inside_tree()):
		$sprites/back.position.x = length - 64
		
		$sprites/middle.position.x = length/2 - 32
		$sprites/middle.region_rect.size.x = max(length - 64 * 2, 0)
		
		$Area2D/CollisionPolygon2D.polygon[2].x = length - 32
		$Area2D/CollisionPolygon2D.polygon[3].x = length - 32
		
		$CollisionPolygon2D.polygon[2].x = length - 32
		$CollisionPolygon2D.polygon[3].x = length - 32

func _physics_process(delta):
	for node in $Area2D.get_overlapping_bodies():
		if(node.is_in_group("player") and node.is_grounded()):
			var dir = 1
			
			if(not is_moving_forward()):
				dir = - 1
			
			node.position.x += speed * delta * dir