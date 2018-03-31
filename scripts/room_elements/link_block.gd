extends StaticBody2D

export var key = ""
export var active = true

func _ready():
	_set_active(active)

func _set_active(value):
	print("UIT")
	if(value):
		set_collision_layer_bit(0,1)
		visible = true
	else:
		set_collision_layer_bit(0,0)
		visible = false

func check_for_key(player):
	if(player.has_in_inventory(key)):
		_set_active(true)
		get_parent().get_node("Area2D").queue_free()
	else:
		_set_active(false)

func on_area_enter(body,value):
	_set_active(value)
