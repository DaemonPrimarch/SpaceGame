extends StaticBody2D

export var key = ""

func _set_active(value):
	if(value):
		set_collision_layer_bit(0,1)
		visible = true
	else:
		set_collision_layer_bit(0,0)
		visible = false

func check_for_key(player):
	if(player.has_in_inventory(key)):
		_set_active(true)
	else:
		_set_active(false)
