extends Polygon2D

export var has_default_camera_pos = false
export var default_camera_pos = Vector2()

export var default_zoom = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func get_default_camera_zoom():
	return default_zoom
	
func get_default_camera_position():
	return default_camera_pos
	
func has_default_camera_position():
	return default_camera_pos
	
func get_global_polygon():
	var pol = []
	
	for p in polygon:
		pol.push_back(to_global(p))
		
	return pol

func _physics_process(delta):
	for camera in get_tree().get_nodes_in_group("camera"):
		
		if(not (camera.is_in_container() and camera.get_container() == self) and MATHS.is_point_in_polygon(camera.get_follow_point(), get_global_polygon())):
			camera.set_container(self)