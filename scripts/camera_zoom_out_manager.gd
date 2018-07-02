extends Node2D

export var zoom_in_time = 0.5
export var zoom_out_time = 4

var zoomed = false

func _ready():
	get_parent().get_parent().connect("state_entered", self, "on_state_entered")
	get_parent().get_parent().connect("state_left", self, "on_state_left")
	
func on_state_entered(state, old_state):
	if(state == "STANDING"):
		get_node("Timer").start()
	
func on_state_left(state, new_state):
	if(state == "STANDING"):
		get_node("Timer").stop()
		if(zoomed):
			get_parent().zoom_to(Vector2(1,1), zoom_in_time)
			zoomed = false

func _on_Timer_timeout():
	if(get_parent().has_limit_area() and get_parent().get_limit_area().can_zoom_out and not zoomed):
		var size = get_parent().get_limit_area().get_AABB().size / get_viewport_rect().size
		var target = min(size.x, size.y)
		get_parent().zoom_to(target * Vector2(1,1), zoom_out_time)

		zoomed = true
	