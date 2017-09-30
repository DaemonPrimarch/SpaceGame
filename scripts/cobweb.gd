extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_Area2D_body_enter( body ):
	if(!body.is_in_group("spider")):
		if(body.is_in_group("player")):
			body.jump_speed = body.jump_speed /2
		body.set_gravity_damp(body.get_gravity_damp()*2)
		body.set_movement_speed(body.get_movement_speed()/2)



func _on_Area2D_body_exit( body ):
	if(!body.is_in_group("spider")):
		if(body.is_in_group("player")):
			body.jump_speed = body.jump_speed *2
		body.set_gravity_damp(body.get_gravity_damp()/2)
		body.set_movement_speed(body.get_movement_speed()*2)
