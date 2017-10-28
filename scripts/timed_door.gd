extends StaticBody2D

onready var timer_open = get_node("Timer_open")
onready var timer_closed = get_node("Timer_closed")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_hidden(true)
	timer_open.start()


func _on_Timer_open_timeout():
	set_hidden(not is_hidden())
	timer_closed.start()
	timer_open.stop()


func _on_Timer_closed_timeout():
	set_hidden(not is_hidden())
	timer_closed.stop()
	timer_open.start()
