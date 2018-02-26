extends "res://scripts/damage_area.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _on_active_timer_timeout():
	set_active(false)


func _on_nonactive_timer_timeout():
	set_active(true)



func _on_damage_area_activated():
	if(not Engine.editor_hint):
		get_node("active_timer").start()
		get_node("non-active_timer").stop()


func _on_damage_area_deactivated():
	if(not Engine.editor_hint):
		get_node("non-active_timer").start()
		get_node("active_timer").stop()
