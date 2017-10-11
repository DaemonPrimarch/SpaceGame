extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var original_state

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass



func _on_ladder_body_enter( body ):
	if(body.is_in_group("player")):
		original_state = body.get_current_state()
		body.set_current_state(body.STATE.CLIMBING)


func _on_ladder_body_exit( body ):
	if(body.is_in_group("player")):
		body.set_current_state(original_state)


