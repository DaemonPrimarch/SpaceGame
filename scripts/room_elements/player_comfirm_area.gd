extends Area2D

signal comfirmed_by(player)
signal comfirmed

export var enabled = true

func is_enabled():
	return enabled

func set_enabled(val):
	enabled = val

func _physics_process(delta):
	if(not get_overlapping_bodies().empty() and is_enabled()):
		get_node('Label').visible = true
		if(Input.is_action_just_pressed("ui_accept")):
			emit_signal("comfirmed_by", get_overlapping_bodies()[0])
			emit_signal("comfirmed")
			get_node('Label').visible = false
			set_enabled(false)
	else:
		get_node('Label').visible = false
