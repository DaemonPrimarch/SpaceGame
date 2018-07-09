tool

extends Area2D

signal comfirmed_by(player)
signal comfirmed

export var enabled = true
export var one_time = true

func is_enabled():
	return enabled

func set_enabled(val):
	enabled = val

func _physics_process(delta):
	get_node('Label').visible = false
	
	if(is_enabled()):
		for node in get_overlapping_bodies():
			if(node.is_in_group("player")):	
				get_node('Label').visible = true
				if(Input.is_action_just_pressed("ui_accept")):
					emit_signal("comfirmed_by", node)
					emit_signal("comfirmed")
					
					if(one_time):
						queue_free()
