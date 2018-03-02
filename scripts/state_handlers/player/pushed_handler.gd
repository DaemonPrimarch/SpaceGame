extends "res://scripts/state_handler.gd"

export var damage_push_height = 60
export var damage_push_distance = 32
export var damage_push_time = 0.125

var pushed_timer

func _ready():
	set_no_gravity(true)

func get_handled_state():
	return "PUSHED"


func enter_state(previous_state):
	.enter_state(previous_state)
			
	pushed_timer = 0
	get_parent().set_velocity(calculate_starting_velocity())
	get_parent().animation_player.play("jump")


func process_state(delta):
	.process_state(delta)
	
	pushed_timer += delta
	if(pushed_timer < damage_push_time):
		var vertical_collision_info  = get_parent().move_and_collide(get_parent().get_velocity() * Vector2(0,1) * delta)
		var horizontal_collision_info  = get_parent().move_and_collide(get_parent().get_velocity() * Vector2(1,0) * delta)
		
		if (vertical_collision_info != null):
			get_parent().set_velocity(Vector2(get_parent().get_velocity().x,0))
			get_parent().set_state("FALLING")
		
		if(horizontal_collision_info != null):
			get_parent().set_velocity(Vector2(0,0))
			get_parent().set_state("FALLING")
	else:
		get_parent().set_velocity(Vector2(0,0))
		get_parent().set_state("FALLING")


func leave_state(new_state):
	.leave_state(new_state)
	get_parent().is_pushed = false

func calculate_starting_velocity():
	return Vector2(get_parent().push_direction * (damage_push_distance/damage_push_time), -damage_push_height/damage_push_time)