extends Node2D

func _ready():
	get_parent().connect("state_entered", self, "on_state_entered")
	get_parent().connect("state_left", self, "on_state_left")
	
func on_state_entered(state, old_state):
	if(state == "STANDING"):
		get_node("Timer").start()
	
func on_state_left(state, new_state):
	if(state == "STANDING"):
		get_node("Timer").stop()

func _on_Timer_timeout():
	get_parent().get_node("camera2").zoom_to(1.0/get_node("/root/MATHS").get_aabb_of_polygon(get_node("/root/ROOM_MANAGER").get_room_of_node(self).get_node("camera_container").polygon).size.y * get_viewport_rect().size.y, 4)
	