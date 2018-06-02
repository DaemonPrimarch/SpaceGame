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
	if(not get_overlapping_bodies().empty() and is_enabled() and get_overlapping_bodies().has(get_node("/root/ROOM_MANAGER").get_room_of_node(self).get_node("player"))):
			get_node('Label').visible = true
			if(Input.is_action_just_pressed("ui_accept")):
				emit_signal("comfirmed_by", get_overlapping_bodies().has(get_node("/root/ROOM_MANAGER").get_room_of_node(self).get_node("player")))
				emit_signal("comfirmed")
				get_node('Label').visible = false
				
				if(one_time):
					queue_free()
	else:
		get_node('Label').visible = false
