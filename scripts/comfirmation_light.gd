tool

extends Sprite

export var active = false setget set_active, is_active
export var active_color = Color(0,1,0,0.7)
export var inactive_color = Color(1,0,0,0.7)

func set_active(val):
	if(val != is_active()):
		active = val
		
		if(val):
			set_modulate(active_color)
		else:
			set_modulate(inactive_color)

func is_active():
	return active
	
	
