extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass



func _on_Ladder_body_enter( body ):
	if(body.is_in_group("player")):
		body.set_climbing(true)


func _on_Ladder_body_exit( body ):
	if(body.is_in_group("player")):
		body.set_climbing(false)
