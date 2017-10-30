extends "res://scripts/trigger.gd"

onready var label = get_node("label")

export var text_to_display = "PRESS BUTTON!"

var bodies_inside = 0

func is_body_inside():
	return bodies_inside > 0
	

func _input(event):
	if(event.is_action_pressed("ui_accept")):
		emit_signal("triggered")
	
func _on_body_enter( body ):
	if(body.is_in_group("player")):
		bodies_inside += 1
		set_process_input(true)
		label.set_text(text_to_display)
	

func _on_body_exit( body ):
	if(body.is_in_group("player")):
		bodies_inside -= 1
		
		if(bodies_inside <= 0):
			label.set_text("")
			set_process(false)
