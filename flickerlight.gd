extends Node2D

export var light_enabled = true
onready var timer = get_node("Timer")

func _ready():
	var enabled = light_enabled
	light_enabled = false
	set_light_enabled(enabled)
	
func is_light_enabled():
	return light_enabled
	
func set_light_enabled(val):
	if(val != is_light_enabled()):
		if(val):
			get_node("Light2D").set_enabled(true)
			get_node("Sprite").set_frame(0)
		else:
			get_node("Light2D").set_enabled(false)
			get_node("Sprite").set_frame(1)
		light_enabled = val
		
	
func toggle():
	set_light_enabled(!is_light_enabled())

func _on_Timer_timeout():
	toggle()
	timer.start()
