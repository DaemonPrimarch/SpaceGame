extends Area2D

var confirmed = false
signal confirmed(body)

func _physics_process(delta):
	if(not get_overlapping_bodies().empty() and not confirmed):
		get_node('Label').visible = true
		if(Input.is_action_just_pressed("ui_accept")):
			emit_signal("confirmed", get_overlapping_bodies()[0])
			get_node('Label').visible = false
			confirmed = true
	else:
		get_node('Label').visible = false
