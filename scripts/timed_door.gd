extends StaticBody2D

onready var timer_open = get_node("Timer_open")
onready var timer_closed = get_node("Timer_closed")

func hide(value):
	set_hidden(value)
	set_layer_mask_bit(1, not value)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	hide(true)
	timer_open.start()


func _on_Timer_open_timeout():
	hide(not is_hidden())
	timer_closed.start()
	timer_open.stop()


func _on_Timer_closed_timeout():
	hide(not is_hidden())
	timer_closed.stop()
	timer_open.start()
