extends Node2D

var cooling_down = false
export var has_cooldown = true
export(float, 0, 10, 0.1) var cooldown_time = 1.0
onready var timer
export var start_on_press = true

var holding = false

func is_holding_trigger():
	pass

func is_cooling_down():
	return cooling_down

func has_cooldown_timer():
	return has_cooldown

func _ready():
	if(has_cooldown_timer()):
		timer = Timer.new()
		timer.set_name("cooldown_timer")
		timer.set_wait_time(cooldown_time)
		
		timer.connect("timeout", self, "_on_cooldown_timer_timeout")
		
		add_child(timer)
	set_process(true)

func _process(delta):
	if(Input.is_action_pressed("shoot")):
		if(not is_holding_trigger()):
			holding = true
			if(start_on_press):
				if(cooldown_timer_running()):
					press_trigger()
			else:
				press_trigger()
		is_holding_trigger()
	elif(is_holding_trigger()):
		holding = false
		if(!start_on_press):
			if(cooldown_timer_running()):
				release_trigger()
		else:
			release_trigger()

func press_trigger():
	pass

func release_trigger():
	pass

func _on_cooldown_timer_timeout():
	cooling_down = false

func cooldown_timer_running():
	if(!cooling_down):
		if(has_cooldown_timer()):
			timer.start()
			cooling_down = true
		return true
	return false