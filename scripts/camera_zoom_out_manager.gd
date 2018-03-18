extends Node2D

var zoomed = false

func _ready():
	get_parent().connect("state_entered", self, "on_state_entered")
	get_parent().connect("state_left", self, "on_state_left")
	
func on_state_entered(state, old_state):
	if(state == "STANDING"):
		get_node("Timer").start()
	
func on_state_left(state, new_state):
	if(state == "STANDING"):
		get_node("Timer").stop()
		if(zoomed):
			get_parent().get_node("camera2").zoom_to(1, 0.5)
			zoomed = false

func _on_Timer_timeout():
	var size = get_node("/root/MATHS").get_aabb_of_polygon(get_parent().get_node("camera2").get_container().polygon).size / get_viewport_rect().size
	
	var target = 1.0/min(size.x, size.y)
	
	get_parent().get_node("camera2").zoom_to(target, 4)
	
	zoomed = true
	