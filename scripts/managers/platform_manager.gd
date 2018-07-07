extends Node2D

var platform = null

func is_on_platform():
	return platform != null

func set_platform(p_platform):
	platform = p_platform

func get_platform():
	return platform

func _ready():
	get_parent().add_to_group("handles_platform")
	
	
