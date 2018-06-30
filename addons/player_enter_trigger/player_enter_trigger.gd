tool
extends Area2D

signal player_entered(player)
signal triggered

export var enabled = true
export var oneshot = false
export var free_on_disabled = false
export(String) var save_path
export var trigger_on_freed = false

func set_enabled(val):
	enabled = val
	
	if(not val):
		if(free_on_disabled):
			unload()

func is_enabled():
	return enabled

func is_oneshot():
	return oneshot

func saves_oneshot():
	print("SAVE: ",save_path != null)
	return save_path != null
	
func _ready():
	connect("body_entered", self, "_on_Area2D_body_entered")
	
	if(not Engine.editor_hint and is_oneshot() and saves_oneshot() and get_node("/root/SAVE_MANAGER").has_property(save_path) and get_node("/root/SAVE_MANAGER").get_property(save_path) and free_on_disabled):
		if(trigger_on_freed):
			call_deferred("emit_signal", "triggered")
		unload()

func _on_Area2D_body_entered(body):
	if(body.is_in_group("player") and is_enabled()):
		emit_signal("player_entered", body)
		emit_signal("triggered")
		
		if(is_oneshot()):
			if(saves_oneshot()):
				get_node("/root/SAVE_MANAGER").set_property(save_path, true)
			set_enabled(false)

func unload():
	queue_free() 
