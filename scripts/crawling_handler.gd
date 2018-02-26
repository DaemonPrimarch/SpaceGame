extends "res://scripts/state_handler.gd"

func get_handled_state():
	return "CRAWLING"

func _ready():
	set_no_gravity(true)

func enter_state(previous_state):
	.enter_state(previous_state)

	get_parent().position += (Vector2(64, 10) * get_parent().get_direction())
	get_parent().scale *= Vector2(1, 0.5)
	
	print("CRAWL ENTER")

	get_parent().animation_player.play("jump")

func leave_state(new_state):
	.leave_state(new_state)

	get_parent().scale *= Vector2(1, 2)

func process_state(delta):
	.process_state(delta)

	get_parent().get_node("crawl_leave_detector").force_raycast_update()

	if(not get_parent().get_node("crawl_leave_detector").is_colliding()):
		get_parent().set_state(get_parent().STATES.STANDING)
	else:
		var pressed = 0

		if(Input.is_action_pressed("play_left")):
			get_parent().set_flippedH(true)
			pressed = 1
		elif(Input.is_action_pressed("play_right")):
			get_parent().set_flippedH(false)
			pressed = 1

		get_parent().move_and_collide(get_parent().get_direction() * get_parent().get_movement_speed() * Vector2(1,0) * pressed * delta)