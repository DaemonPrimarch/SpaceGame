extends Path2D

export var active = true
export var one_way = false
export var moving_speed = 64 * 3

var next_point_index = 1
var prev_point_index = 0
var direction = 1

signal platform_loaded()
signal arrived_at_point(point)
signal arrived_at_end()

var platform = null

func get_movement_speed():
	return moving_speed

func is_one_way():
	return one_way

func is_moving():
	return is_active()

func get_platform():
	return platform

func get_next_point():
	return curve.get_point_position(next_point_index)

func get_previous_point():
	return curve.get_point_position(prev_point_index)

func get_movement_direction():
	return (get_next_point() - get_platform().get_position()).normalized()

func has_arrived_at_next_point():
	return ((get_next_point() - get_previous_point()).dot(get_movement_direction()) <= 0)

func init_platform():
	for child in get_children():
		if(child.is_in_group("platform")):
			platform = child
	
func _ready():
	init_platform()
	
	emit_signal("platform_loaded")

	get_platform().position = get_previous_point()
	
func get_velocity():
	return (get_next_point() - get_previous_point()) / (get_next_point() - get_previous_point()).length() * get_movement_speed()

func advance_next_point():
	if(next_point_index >= curve.get_point_count() - 1 or next_point_index <= 0):
		if(is_one_way()):
			set_active(false)
			emit_signal("arrived_at_end")
		direction = -direction
		
	prev_point_index = next_point_index
	next_point_index += direction
			
func _physics_process(delta):
	if(is_active() and curve != null):
		get_platform().move_and_push(get_velocity() * delta)
		
		if(has_arrived_at_next_point()):
			#get_platform().position = get_next_point()
			
			emit_signal("arrived_at_point", get_next_point())
			advance_next_point()

func set_active(value):
	active = value

func is_active():
	return active
	
