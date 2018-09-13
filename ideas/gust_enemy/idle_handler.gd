extends "res://addons/state_handler/state_handler.gd"

func _on_bullet_hit_manager_bullet_hit(bullet):
	bullet_hit = true

var bullet_hit = false
func enter_state(old):
	.enter_state(old)
	
	bullet_hit = false

func process_state(delta):
	.process_state(delta)
	
	if(bullet_hit):
		get_parent().set_state("AIR_BLASTING")