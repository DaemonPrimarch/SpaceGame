extends Node2D

var cooling_down = false
export var has_cooldown = true
export(float, 0, 10, 0.1) var cooldown_time = 1.0

var holding = false

func is_holding_trigger():
	return holding

func is_cooling_down():
	return cooling_down

func has_cooldown_timer():
	return has_cooldown

func _ready():
	if(has_cooldown_timer()):
		var timer = Timer.new()
		timer.set_name("cooldown_timer")
		timer.set_wait_time(cooldown_time)
		
		timer.connect("timeout", self, "_on_cooldown_timer_timeout")
		
		add_child(timer)
	set_process(true)
	
func _process(delta):
	if(Input.is_action_pressed("shoot")):
		if(not is_holding_trigger()):
			holding = true
			press_trigger()
		is_holding_trigger()
	elif(is_holding_trigger()):
		holding = false
		loose_trigger()

func press_trigger():
	pass
func hold_trigger():
	if(has_cooldown_timer()):
		if(not is_cooling_down()):
			fire()
			get_node("cooldown_timer").start()
			cooling_down = true
			
	else:
		fire()
		
func loose_trigger():
	pass

func _on_cooldown_timer_timeout():
	cooling_down = false
