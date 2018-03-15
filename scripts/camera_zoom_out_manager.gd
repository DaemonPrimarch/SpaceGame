extends Node2D

func _ready():
	get_parent().connect("state_entered", self, "on_state_entered")
	get_parent().connect("state_left", self, "on_state_left")
	
func on_state_entered(state):
	if(state == "STANDING"):
		get_node("Timer").start()
	
func on_state_left(state):
	if(state == "STANDING"):
		get_node("Timer").reset()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Timer_timeout():
	pass # replace with function body
	