extends Label

signal finished_displaying

var scrolling = false
var total_text = ""
var text_position = 0
onready var scroll_timer = get_node("text_scroll_timer")

func is_scrolling():
	return scrolling

func set_total_text(text):
	total_text = text

func get_total_text():
	return total_text

func display():
	text_position = 0
	if(is_scrolling()):
		set_text("")
		scroll_timer.start()
	else:
		set_text(get_total_text())

func _ready():
	pass

func _on_text_scroll_timer_timeout():
	text_position += 1
	if(text_position == get_total_text().length()):
		text_position = 0
		scroll_timer.stop()
		emit_signal("finished_displaying")
	else:
		set_text(get_total_text().left(text_position))