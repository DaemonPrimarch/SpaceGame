extends Node2D

var last_safe_position = Vector2()

func _ready():
	get_node("ground_detector").add_exception(get_parent())
	get_parent().connect("crushed", self, "respawn")
	
func respawn():
	get_parent().warp_to(get_respawn_position())
	
	get_parent().call_deferred("set_state", "STANDING")
func set_respawn_position(point):
	last_safe_position = point

func get_respawn_position():
	return last_safe_position

func _physics_process(delta):
	get_node("ground_detector").force_raycast_update()
	
	if(not get_parent().is_inside_helper_area("no_respawn") and get_parent().is_grounded() and get_node("ground_detector").is_colliding() and get_node("ground_detector").get_collider().is_in_group("terrain")):
		last_safe_position = get_parent().global_position
		