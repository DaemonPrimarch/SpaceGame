extends Area2D

signal player_entered(player)
signal player_entered_no_par()

export var oneshot = false
export(String) var save_path

func is_oneshot():
	return oneshot

func saves_oneshot():
	print("SAVE: ",save_path != null)
	return save_path != null
	
func _ready():
	if(is_oneshot() and saves_oneshot() and get_node("/root/SAVE_MANAGER").has_property(save_path) and get_node("/root/SAVE_MANAGER").get_property(save_path)):
		queue_free()

func _on_Area2D_body_entered(body):
	if(body.is_in_group("player")):
		emit_signal("player_entered", body)
		emit_signal("player_entered_no_par")
		
		if(is_oneshot()):
			if(saves_oneshot()):
				get_node("/root/SAVE_MANAGER").set_property(save_path, true)
		
			queue_free() 
