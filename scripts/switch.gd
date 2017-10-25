extends Node2D

signal switch_on
signal switch_off

export var on = false

var enabled = false

var first = true

func _ready():
	set_on(on)

func set_on(value):
	if(value != enabled or first):
		print("hit: ", value)
		first = false
		if(value):
			emit_signal("switch_on")
		else:
			emit_signal("switch_off")
	enabled = value
	
func is_on():
	return enabled
	
func toggle():
	set_on(not is_on())