extends Area2D

signal player_entered(player)
signal triggered

export var oneshot = false
export(String) var save_path
export var trigger_on_unload = false

func is_oneshot():
	return oneshot

func saves_oneshot():
	print("SAVE: ",save_path != null)
	return save_path != null
	
func _ready():
	if(is_oneshot() and saves_oneshot() and get_node("/root/SAVE_MANAGER").has_property(save_path) and get_node("/root/SAVE_MANAGER").get_property(save_path)):		
		if(trigger_on_unload):
			call_deferred("emit_signal", "triggered")
		unload()

func _on_Area2D_body_entered(body):
	if(body.is_in_group("player")):
		emit_signal("player_entered", body)
		emit_signal("triggered")
		
		if(is_oneshot()):
			if(saves_oneshot()):
				get_node("/root/SAVE_MANAGER").set_property(save_path, true)
			unload()

func unload():
	queue_free() 
