extends Node2D

var platform = null
signal end_reached
signal start_reached
signal breakpoint_reached

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
		current_extending_index = extending_distances.size() - 1
		get_platform().move_and_push(get_extending_direction() * extending_distances[current_extending_index] * flipped * Vector2(1,-1))
		moving_forward = false
		current_extending_index -= 1
		if(step):
			current_extending_index = extending_distances.size() - 1
	else:
		current_extending_index = 1
		if(step):
			current_extending_index = 0

export var active = true
export var step = false
export var extended = false
export var extending_direction = Vector2(1,0)
export var extending_distances = PoolIntArray()
var current_extending_index = 0

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
			
			
			if((extending_direction * extending_distances[current_extending_index] - get_platform().get_position() * flipped * Vector2(1,-1)).normalized().dot((extending_direction * extending_distances[current_extending_index]).normalized()) <= 0):
				forward_velocity = forward_starting_velocity
				if(step):
					set_active(false)
				else:
					if(current_extending_index == extending_distances.size() - 1):
						moving_forward = false
						emit_signal("end_reached")
						current_extending_index -= 1
					else:
						current_extending_index += 1
						emit_signal("breakpoint_reached")

		else:
			get_platform().move_and_push(get_extending_direction() * backward_velocity * delta * -1 * flipped * Vector2(1,-1))

			backward_velocity += backward_acceleration * delta
			
			var comp = 0
			if(extending_direction.x>0):
				comp = -get_platform().position.x - extending_distances[current_extending_index]
			else:
				comp = -get_platform().position.y - extending_distances[current_extending_index]
			if(comp*flipped <= 0):
				if(step):
					set_active(false)
				else:
					if(current_extending_index == 0):
						moving_forward = true
						emit_signal("start_reached")
						current_extending_index += 1
					else:
						current_extending_index -= 1
						emit_signal("breakpoint_reached")
				backward_velocity = backward_starting_velocity

func switch(index):
	if(not is_active()):
		if(current_extending_index == index):
			current_extending_index = index + 1
			moving_forward = true
			set_active(true)
		elif(current_extending_index == index + 1):
			current_extending_index = index
			moving_forward = false
			set_active(true)
