extends Node2D

var platform = null
signal end_reached
signal start_reached

func get_platform():
	return platform

func _ready():
	for node in get_children():
		if(node.is_in_group("platform")):
			platform = node
			
	get_platform().position = Vector2()
	
	var flipped = 1
			
	if(get_platform().is_flippedH() or get_platform().is_flippedV()):
		flipped = -1
	
	if(extended):
		get_platform().move_and_push(get_extending_direction() * extending_distance * flipped * Vector2(1,-1))
		moving_forward = false
		forward_velocity = forward_starting_velocity

export var active = true
export var one_way = false
export var extended = false
export var extending_direction = Vector2(1,0)
export var extending_distance = 64

export var forward_starting_velocity = 64*5
export var forward_acceleration = 64*3

export var backward_starting_velocity = 64
export var backward_acceleration = 64

var forward_velocity = forward_starting_velocity
var backward_velocity = backward_starting_velocity

var moving_forward = true

func set_active(value):
	active = value

func is_active():
	return active

func is_one_way():
	return one_way

func get_extending_direction():
	return extending_direction

func _physics_process(delta):
	if(is_active()):
		var flipped = 1
			
		if(get_platform().is_flippedH() or get_platform().is_flippedV()):
			flipped = -1
		if(moving_forward):
			get_platform().move_and_push(get_extending_direction() * forward_velocity * delta * flipped * Vector2(1,-1))
			
			forward_velocity += forward_acceleration * delta
			
			
			if((extending_direction * extending_distance - get_platform().get_position() * flipped * Vector2(1,-1)).normalized().dot((extending_direction * extending_distance).normalized()) <= 0):
				moving_forward = false
				
				forward_velocity = forward_starting_velocity
				emit_signal("end_reached")
		else:
			get_platform().move_and_push(get_extending_direction() * backward_velocity * delta * -1 * flipped * Vector2(1,-1))

			backward_velocity += backward_acceleration * delta

			if((get_platform().get_position() * flipped * Vector2(1,-1)).normalized().dot((extending_direction * extending_distance).normalized()) <= 0):
				moving_forward = true

				backward_velocity = backward_starting_velocity
				emit_signal("start_reached")
				if(is_one_way()):
					set_active(false)
